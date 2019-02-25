#!/usr/bin/env perl

use DateTime::Format::Strptime;
use Getopt::Long;
use Time::Piece;
use feature qw{ say };
use strict;
use warnings;
use Carp;

my $opts = {};
GetOptions( $opts, "--begin=s", "--end=s", "--regex=s", "--format=s" );

my $log_time_parser = DateTime::Format::Strptime->new(
  pattern  => $opts->{format},
  on_error => 'croak',
);

my $supplied_time_parser = DateTime::Format::Strptime->new(
  pattern  => '%FT%T',
  on_error => 'croak',
);

my $regex      = qr/$opts->{regex}/;

my $low_needle = $supplied_time_parser->parse_datetime( $opts->{begin} );
my $high_needle = $supplied_time_parser->parse_datetime( $opts->{end} );

while ( my $line = <> ) {
  unless ( $line =~ /$regex/ ) {
    next;
  }
  my $t = $log_time_parser->parse_datetime($time);
  if ( $t >= $low_needle && $t <= $high_needle ) {
    print $line;
  }
}
