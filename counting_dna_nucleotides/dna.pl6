#!/usr/bin/env perl6

my $dna = $*IN.lines;
my @nucleic_acide = <A C G T>;
my $dna_bag = $dna.comb.Bag;
say @nucleic_acide.map({$dna_bag{$_}}).join(" ");
