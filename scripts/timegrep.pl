#!/usr/bin/env perl

use Carp;
use DateTime::Format::Strptime;
use Getopt::Long;
use List::BinarySearch qw { binsearch_range };
use feature qw{ say };
use strict;
use warnings;

my $opts = {};
GetOptions( $opts, "--start=s", "--finish=s", "--regexp=s",
  "--time-format=s", "--chunk=i", "--year=i" );

my $chunk = $opts->{chunk} || 8192;

my $log_time_parser = DateTime::Format::Strptime->new(
  pattern  => $opts->{'time-format'},
  on_error => 'croak',
);

my $supplied_time_parser = DateTime::Format::Strptime->new(
  pattern  => '%FT%T',
  on_error => 'croak',
);

my $regex = qr/$opts->{regexp}/;

my @buffer;
my @times;
while ( my $line = <> ) {
  my ($time) = $line =~ /$regex/;
  unless ( defined($time) ) {
    print STDERR $line;
    next;
  }
  push @buffer, $line;
  push @times,  $time;
  if ( @buffer == $chunk || eof ) {
    my ( $low, $high ) = binsearch_range {
      comparable_time($a) <=> comparable_time($b)
    }
    $supplied_time_parser->parse_datetime( $opts->{start} )
      ->strftime( $opts->{'time-format'} ),
      $supplied_time_parser->parse_datetime( $opts->{finish} )
      ->strftime( $opts->{'time-format'} ), @times;

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
