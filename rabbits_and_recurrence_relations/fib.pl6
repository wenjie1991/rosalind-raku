#!/usr/bin/env perl6

my ($month, $productivity) = $*IN.lines[0].words;
# $a: the pair has productivity in last month;
# $b: the pair in last month
my $seq = (1,1,-> $a, $b { $a * $productivity + $b } ... *);
$seq[$month - 1].say;
