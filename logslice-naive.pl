#!/usr/bin/env perl

use DateTime::Format::Strptime;
use Getopt::Long;
use Time::Piece;
use feature qw{ say };
use strict;
use warnings;
use Carp;

my $opts = {};
GetOptions( $opts, "--begin=s", "--end=s", "--regex=s", "--format=s",
  "--chunk=i" );

my $parser = DateTime::Format::Strptime->new(
  pattern  => $opts->{format},
  on_error => 'croak',
);

my $regex      = qr/$opts->{regex}/;
my $chunk      = $opts->{chunk} || 1000;
my $low_needle = DateTime::Format::Strptime->new(
  pattern  => '%FT%T',
  on_error => 'croak',
)->parse_datetime( $opts->{begin} );
my $high_needle = DateTime::Format::Strptime->new(
  pattern  => '%FT%T',
  on_error => 'croak',
)->parse_datetime( $opts->{end} );

my @buffer;
while (<>) {
  push @buffer, $_;
  if ( @buffer == $chunk || eof ) {
    for my $line (@buffer) {
      my ($time) = $line =~ $regex;
      next unless ( defined($time) );
      my $t = $parser->parse_datetime($time);
      if ( $t >= $low_needle && $t <= $high_needle ) {
        print $line;
      }
    }
    @buffer = ();
  }
}
