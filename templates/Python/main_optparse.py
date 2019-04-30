#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Description
"""

__author__ = '<+AUTHOR+> <+MAIL_ADDRESS+>'
__status__ = "production"
__version__ = '0.0.1'
__date__ = '<+DATE+>'

import optparse
import sys


if __name__ == '__main__':
    N_REQUIRED_MEMAININGS = 1
    parser = optparse.OptionParser(
            usage='\n  $ python %prog [options] FILES...',
            version='%prog 0.0.1',
            description='description')
    parser.add_option('-a', '--apple', dest='apple',
            default=False, action='store_true',
            help='apple apple apple')
    parser.add_option('-b', '--banana', dest='banana',
            type='string', default='', action='store', metavar='BANANA',
            help='banana banana banana')
    parser.add_option('-c', '--cake', dest='cake',
            type='int', default='0', action='store', metavar='CAKE',
            help='cake cake cake')
    opts, args = parser.parse_args()
    args = filter(lambda arg: arg != '', args)

    print opts
    print args
    if len(args) < N_REQUIRED_MEMAININGS:
        print 'Specify files one or more'
        parser.print_usage()
        sys.exit(1)
    <+CURSOR+>
