#!/usr/bin/env perl6

#my $fasta = q:to/END/;
#>Rosalind_0498
#AAATAAA
#>Rosalind_2391
#AAATTTT
#>Rosalind_2323
#TTTTCCC
#>Rosalind_0442
#AAATCCC
#>Rosalind_5013
#GGGTGGG
#END
my $fasta = $*IN.slurp;

grammar FASTA::Grammar::DNA {
    token TOP { <record>+ }
    token record { ">"<id><comment>?"\n"<sequence> }
    token id { <-[\ \n]>+ }
    token comment { " "<-[\n]>+ }
    token sequence { <[ACGT\-\n]>+ }
}

class FASTA::Actions {
    method TOP ($/) {
        make $<record>>>.made;
    }
    method record ($/) {
        make {
            id => ~$<id>,
            comment => ($<comment>) ?? (~$<commnet>).trim !! '',
            sequence => $<sequence>.subst("\n", "", :g)
        };
    }
}

my @seqs = FASTA::Grammar::DNA.parse($fasta, actions => FASTA::Actions).made;

for (@seqs X @seqs).flat -> $a, $b {
    next if $a === $b;
    say [$a<id>, $b<id>].join(" ")  if $a<sequence>.substr(*-3) eq $b<sequence>.reverse.substr(0, 3)
}
