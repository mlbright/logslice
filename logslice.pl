#!/usr/bin/env perl

use strict;
use warnings;
use feature qw{ say };
use Getopt::Long;

my $opts = {};
GetOptions( $opts, "--begin=s", "--end=s", "--regex=s", "--format=s",
  "--chunk=i" );

my $regex = qr/$opts->{regex}/;

while ( my $line = <> ) {
  chomp $line;
  if ( $line =~ $regex ) {
    say $line;
  }
}
