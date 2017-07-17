#!/usr/bin/env perl6

#my $n = 3;
my $n = $*IN.lines[0].trim;
my @combinations = (1..$n).permutations;
say @combinations.elems;
say .join(" ") for @combinations;
