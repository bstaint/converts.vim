# coding: utf-8

import base64
import hashlib
import binascii
import urllib.parse

class Converts(object):

    _is_callback = lambda x: x.startswith('_') and not x.endswith('__')

    def __init__(self):
        self._callback = list(filter(Converts._is_callback, dir(self)))

    def parse(self, text, callback, *args):
        func = '_%s' % callback
        if func not in self._callback:
            return text

        func = getattr(self, func)
        return func(text.encode(), *args)

    def _url(self, text, reserved=False):
        ''' urlencode or urldecode '''
        if reserved:
            try: return urllib.parse.unquote(text.decode())
            except TypeError:return text

        return urllib.parse.quote(text)

    def _base64(self, text, reserved=False):
        ''' base64 '''
        if reserved:
            try: return base64.b64decode(text)
            except binascii.Error: return text

        return base64.b64encode(text)

    def _md5(self, text):
        ''' md5 '''
        md5 = hashlib.md5()
        md5.update(text)
        return md5.hexdigest()

    def _dict(self, text, reserved=False):
        if reserved:
            try:
                exec(b'tokens = %s' % text)
                tokens_ = locals()['tokens']
                if isinstance(tokens_, dict):
                    text = urllib.parse.urlencode(tokens_)
            finally:
                return text

        qs = urllib.parse.parse_qsl(self._url(text, True))
        qs = [b'"%s": "%s"' % s for s in qs]

        return b'{ %s }' % b', '.join(qs) if qs else text

conv = Converts()

if __name__ == "__main__":
    conv = Converts()
    print(conv.parse("6bf28ce%20ingo", "url", True))
