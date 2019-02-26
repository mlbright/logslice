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
GetOptions(
  $opts,        "--begin=s", "--end=s", "--regex=s",
  "--format=s", "--chunk=i", "--year=i"
);

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
  next unless ( defined($time) );
  push @buffer, $line;
  push @times,  $time;
  if ( @buffer == $chunk || eof ) {
    my ( $low, $high ) = binsearch_range {
      comparable_time($a) <=> comparable_time($b)
    }
    $supplied_time_parser->parse_datetime( $opts->{begin} )
      ->strftime( $opts->{format} ),
      $supplied_time_parser->parse_datetime( $opts->{end} )
      ->strftime( $opts->{format} ), @times;

    for ( my $i = $low; $i <= $high; $i++ ) {
      print $buffer[$i];
    }
    @buffer = ();
    @times  = ();
  }
}

sub comparable_time {
  my ($t) = @_;
  if ( $opts->{year} ) {
    return $log_time_parser->parse_datetime($t)->set( year => $opts->{year} );
  }
  return $log_time_parser->parse_datetime($t);
}
