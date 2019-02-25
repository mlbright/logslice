#!/usr/bin/env perl

use strict;
use warnings;
use feature qw{ say };
use Getopt::Long;

my $opts = {};
GetOptions( $opts, "--begin=s", "--end=s", "--regex=s", "--format=s",
  "--chunk=i" );

my $regex = qr/$opts->{regex}/;
my $chunk = $opts->{chunk} || 1000;

my @buffer;
while ( <> ) {
  push @buffer, $_;
  if (@buffer == $chunk || eof) {
    for my $line (@buffer) {
      chomp $line;
      if ( $line =~ $regex ) {
        say $line;
      }
    }

    my( $low, $high ) = binsearch_range { $a <=> $b }, $opt->{begin}, $opt->{end}, @haystack;
    @buffer = ();
  }
}
