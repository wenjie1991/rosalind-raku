#!/usr/bin/env perl6

#my $dna = "GATGGAACTTGACTACGTAAATT";
my $dna = $*IN.lines;
$dna.subst("T", "U", :g).say for @$dna;
