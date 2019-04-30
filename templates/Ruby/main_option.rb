#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'

if __FILE__ == $0
  option = {}
  OptionParser.new do |opt|
    opt.on('-a', '--apple', 'apple apple apple') {|value|
      option[:apple] = value
    }
    opt.on('-b', '--banana=VALUE', 'banana banana banana') {|value|
      option[:banana] = value
    }
    opt.on('-c', '--cake=[VALUE]', 'cake cake cake') {|value|
      option[:cake] = value
    }
    opt.on('-d', 'd d d') {|value|
      option[:d] = value
    }
    opt.on('-e VALUE', 'e e e') {|value|
      option[:e] = value
    }
    opt.on('-f [VALUE]', 'f f f') {|value|
      option[:f] = value
    }
    opt.on('--no-grate', 'grate grate grate') {|value|
      option[:grate] = value
    }
    opt.on('--[no-]high', 'high high high') {|value|
      option[:high] = value
    }
    opt.on('-i', '--integers=V,V,...', Array, 'int int int') {|value|
      option[:integers] = value
    }
    opt.on('-j', '--junks=V,V,...', 'junk junk junk') {|value|
      option[:integers] = value
    }
    opt.on('--long=VALUE', 'WHITESPACE_ONLY | SIMPLE_OPTIMIZATIONS | ADVANCED_OPTIMIZATIONS') {|value|
      option[:long] = value
    }
    opt.on('--long_array=VALUE',
           ['WHITESPACE_ONLY', 'SIMPLE_OPTIMIZATIONS', 'ADVANCED_OPTIMIZATIONS'],
           'WHITESPACE_ONLY | SIMPLE_OPTIMIZATIONS | ADVANCED_OPTIMIZATIONS') {|value| option[:long_array] = value}
    opt.on('--long_hash=VALUE',
           {'1'=>'WHITESPACE_ONLY', '2'=>'SIMPLE_OPTIMIZATIONS', '3'=>'ADVANCED_OPTIMIZATIONS'},
           '1 | 2 | 3') {|value| option[:long_hash] = value}
    opt.on('--long_both=VALUE',
           ['WHITESPACE_ONLY', 'SIMPLE_OPTIMIZATIONS', 'ADVANCED_OPTIMIZATIONS'],
           {'1'=>'WHITESPACE_ONLY', '2'=>'SIMPLE_OPTIMIZATIONS', '3'=>'ADVANCED_OPTIMIZATIONS'},
           '1:WHITESPACE_ONLY | 2:SIMPLE_OPTIMIZATIONS | 3:ADVANCED_OPTIMIZATIONS') {|value| option[:long_both] = value}
    opt.on('--rate=VALUE', /\A\d{1,2}\Z|\A100\Z/, '0-100 Percentage.') {|value|
      option[:rate] = value
    }
    opt.parse!(ARGV)
  end
  p option
  p ARGV
  <+CURSOR+>
end
