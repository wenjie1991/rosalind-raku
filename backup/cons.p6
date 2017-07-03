#!/usr/bin/env perl6
use v6;
#use Grammar::Tracer;

my $default_input = Q{
>Rosalind_1
ATCCAGCT
>Rosalind_2
GGGCAACT
>Rosalind_3
ATGGATCT
>Rosalind_4
AAGCAACC
>Rosalind_5
TTGGAACT
>Rosalind_6
ATGCCATT
>Rosalind_7
ATGGCACT
};

my $input = slurp "./rosalind_cons.txt";

grammar fasta_grammar {
    token TOP {
        \n*
        [<DNA_name><DNA_sequence>]+
    }
    token DNA_name {
        \>\N*\n
    }
    token DNA_sequence {
        <[ATGC\n]>*
    }
}
my @dna_types = <A C G T>;

my @sequence = fasta_grammar.parse($input)<DNA_sequence>>>.Str>>.subst(/\n/, "", :g);

my \N = @sequence.pick.chars;

my %profile;
%profile{$_} = [0 xx N] for @dna_types;

for @sequence[] {
    my @dna_seq = .comb;
    my %dna_index_map = classify {@dna_seq[$_]}, ^@dna_seq;
    for %dna_index_map.kv -> $k, $v {
        %profile{$k}[$v[]]>>++;
    }
}

say my $consencus = [~] gather 
for ^N -> \c {
    my $max = max map {%profile{$_}[c]}, @dna_types;
    take [$_] given first {%profile{$_}[c] == $max}, @dna_types;
}

say [~] $_, ": ", %profile{$_} for @dna_types.sort;
