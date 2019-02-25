#!/usr/bin/env perl

use strict;
use warnings;
use feature qw{ say };

open my $ha, '<', 'haproxy.log';
while (my $line = <$ha>) {
  chomp $line;
  if ($line =~ m{\[\d+\/\w+\/\d\d\d\d:\d\d:\d\d:\d\d\.\d+\]}) {
    say $line;
  }
}
