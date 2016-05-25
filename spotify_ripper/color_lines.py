from __future__ import unicode_literals

from spotify_ripper.utils import *


def green(text):
    return '%s%s%s' % (Fore.GREEN, text, Fore.RESET)


def red(text):
    return '%s%s%s' % (Fore.RED, text, Fore.RESET)


def yellow(text):
    return '%s%s%s' % (Fore.YELLOW, text, Fore.RESET)


def cyan(text):
    return '%s%s%s' % (Fore.CYAN, text, Fore.RESET)
