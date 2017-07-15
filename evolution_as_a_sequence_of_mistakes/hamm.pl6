#!/usr/bin/env perl6

my ($s, $t) = $*IN.lines[0, 1];
($s.comb Z $t.comb).map({!($_[0] eq $_[1])}).sum.say;
