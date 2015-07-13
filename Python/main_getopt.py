#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Description
"""

__author__ = '<+AUTHOR+> <+MAIL_ADDRESS+>'
__status__ = "production"
__version__ = '0.0.1'
__date__ = '<+DATE+>'

import getopt
import sys


if __name__ == '__main__':
    N_REQUIRED_MEMAININGS = 1
    opts, args = getopt.gnu_getopt(sys.argv, 'ab:c:', ['apple', 'banana', 'cake'])
    args = filter(lambda arg: arg != '', args)

    print opts
    print args
    if len(args) - 1 < N_REQUIRED_MEMAININGS:
        print 'Specify files one or more'
        sys.exit(1)
    <+CURSOR+>
