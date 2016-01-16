#!/usr/bin/env perl

use strict;
use utf8;
use warnings;


if ($0 eq __FILE__) {
  while (defined(my $line = <STDIN>)) {
    $line =~ s/\s+$//;
    my @tokens = split(/ +/, $line);
    my $a = $tokens[0];
    my $b = $tokens[1];
    <+CURSOR+>
  }
}
