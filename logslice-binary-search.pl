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

my $chunk = $opts->{chunk} || 8192;

my $log_time_parser = DateTime::Format::Strptime->new(
  pattern  => $opts->{format},
  on_error => 'croak',
);

my $supplied_time_parser = DateTime::Format::Strptime->new(
  pattern  => '%FT%T',
  on_error => 'croak',
);

my $regex = qr/$opts->{regex}/;

my @buffer;
my @times;
while ( my $line = <> ) {
  my ($time) = $line =~ /$regex/;
  next unless(defined($time));
  push @times, $time;
  push @buffer, $line;
  if ( @buffer == $chunk || eof ) {
    my ( $low, $high ) = binsearch_range {
      $log_time_parser->parse_datetime($a)
        <=> $log_time_parser->parse_datetime($b)
    }
    $supplied_time_parser->parse_datetime( $opts->{begin} )
      ->strftime( $opts->{format} ),
      $supplied_time_parser->parse_datetime( $opts->{end} )
      ->strftime( $opts->{format} ), @times;

    for ( my $i = $low; $i <= $high; $i++ ) {
      print $buffer[$i];
    }
    @buffer = ();
    @times = ();
  }
}
