#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Description
"""

__author__ = '<+AUTHOR+> <+MAIL_ADDRESS+>'
__status__ = "production"
__version__ = '0.0.1'
__date__ = '<+DATE+>'

import argparse


if __name__ == '__main__':
    N_REQUIRED_MEMAININGS = 1
    parser = argparse.ArgumentParser(
            usage='\n  $ python %(prog)s [options] FILES...',
            description='Description',
            epilog='Epilog')
    parser.add_argument('-a', '--apple', dest='apple',
            default=False, action='store_true',
            help='apple apple apple')
    parser.add_argument('-b', '--banana', dest='banana',
            default='', type=str, action='store', metavar='BANANA',
            help='banana banana banana')
    parser.add_argument('-c', '--cake', dest='cake',
            default=0, type=int, action='store', metavar='CAKE',
            help='cake cake cake')
    # parser.add_argument('rems', dest='rems', nargs='+', required=True,
    #         default='', type=str, action='store', metavar='ARGS',
    #         help='args args args')

    # parser.add_argument('--sum', dest='accumulate', action='store_const',
    #         const=sum, default=max,
    #         help='sum the integers (default: find the max)')

    args = parser.parse_args()
    print args
    # print args.accumulate(args.integers)
    # print opts
    # print rems
    # if len(rems) < N_REQUIRED_MEMAININGS:
    #     print 'Specify files one or more'
    #     exit(1)
    # <+CURSOR+>
