#!/usr/bin/env perl

use DateTime::Format::Strptime;
use Getopt::Long;
use Time::Piece;
use feature qw{ say };
use strict;
use warnings;
use Carp;
use List::BinarySearch qw { binsearch_range };

my $opts = {};
GetOptions( $opts, "--begin=s", "--end=s", "--regex=s", "--format=s",
  "--chunk=i" );

my $chunk = $opts->{chunk} || 4096;

my $parser = DateTime::Format::Strptime->new(
  pattern  => $opts->{format},
  on_error => 'croak',
);

my $regex      = qr/$opts->{regex}/;
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
      my ( $low, $high )
        = binsearch_range { log_record($a) <=> log_record($b) } $low_needle,
        $high_needle, @buffer;
      for my $line ( @buffer[ $low, $high ] ) {
        print $line;
      }
      @buffer = ();
    }
  }
}

sub log_record {
  my ($line) = @_;
  my ($time) = $line =~ $regex;
  return $parser->parse_datetime($time);
}
