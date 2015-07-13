#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'

if __FILE__ == $0
  # option = ARGV.getopts('ab:c:', 'apple', 'banana', 'cake:')
  option = ARGV.getopts('', 'apple', 'banana:', 'cake:CAKE')
  p option
  p ARGV
  <+CURSOR+>
end
