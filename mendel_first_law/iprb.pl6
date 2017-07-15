#!/usr/bin/env perl6

my ($k, $m, $n) = $*IN.lines[0].words;
my $s = $k + $m + $n;


(($k/$s * ($k-1)/($s-1)) +  # k x k
  ($k/$s * $m/($s-1) * 2) +  # k x m
  ($k/$s * $n/($s-1) * 2) +  # k x n
  ($m/$s * ($m-1)/($s-1) * 2 * 3/4 / 2) +  # m x m 
  ($m/$s * $n/($s-1) * 2 / 2)).say;  # m x n

