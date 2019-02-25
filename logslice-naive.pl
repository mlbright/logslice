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
my $low_needle = Time::Piece->strptime($opts->{begin},"%Y-%m-%dT%T");
my $high_needle = Time::Piece->strptime($opts->{end},"%Y-%m-%dT%T");
say $low_needle;
say $high_needle;

my @buffer;
while ( <> ) {
  push @buffer, $_;
  if (@buffer == $chunk || eof) {
    for my $line (@buffer) {
      chomp $line;
      my ($time) = $line =~ $regex;
      my $t = Time::Piece->strptime($time,"%m/%B/%Y:%H:%M:%s.%.3N");
      # my ( $low, $high ) = binsearch_range { $a <=> $b }, $low_needle, $high_needle, @buffer;
      say $t;
      say $line;
    }
    @buffer = ();
  }
}
