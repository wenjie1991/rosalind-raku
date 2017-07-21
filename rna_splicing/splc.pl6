#!/usr/bin/env perl6


grammar FASTA::Grammar {
    token TOP { <record>+ }
    token record { ">"<id><comment>?"\n"<sequence> }
    token id { <-[\ \n]>+ }
    token comment { " "<-[\n]>+ }
    token sequence { <[A..Z\-\n]>+ }
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


multi MAIN() {
    my $fasta = $*IN.slurp;
    my @seqs = FASTA::Grammar.parse($fasta, actions => FASTA::Actions).made.map({$_<sequence>});

    for 1..^@seqs.elems -> $i {
        @seqs[0].=subst(@seqs[$i], "");
    }

    my $rna = @seqs[0].subst("T", "U", :g);
    say transcript($rna);
}

my $rna_codon_table = q:to/END/;
UUU F      CUU L      AUU I      GUU V
UUC F      CUC L      AUC I      GUC V
UUA L      CUA L      AUA I      GUA V
UUG L      CUG L      AUG M      GUG V
UCU S      CCU P      ACU T      GCU A
UCC S      CCC P      ACC T      GCC A
UCA S      CCA P      ACA T      GCA A
UCG S      CCG P      ACG T      GCG A
UAU Y      CAU H      AAU N      GAU D
UAC Y      CAC H      AAC N      GAC D
UAA Stop   CAA Q      AAA K      GAA E
UAG Stop   CAG Q      AAG K      GAG E
UGU C      CGU R      AGU S      GGU G
UGC C      CGC R      AGC S      GGC G
UGA Stop   CGA R      AGA R      GGA G
UGG W      CGG R      AGG R      GGG G 
END

my %rna_codon_table = $rna_codon_table.words.hash;

sub transcript($rna) {
    my Str $peptides;
    for ($rna ~~ m:g/.../)>>.Str -> $code {
        my $aa = %rna_codon_table{$code};
        if ($aa eq "Stop") {
            return $peptides;
            last;
        }  else {
            $peptides ~= $aa;
        }
    }
    return $peptides ~ "-";
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
RNA Splicing
L<http://rosalind.info/problems/splc/>

=input 
>Rosalind_10
ATGGTCTACATAGCTGACAAACAGCACGTAGCAATCGGTCGAATCTCGAGAGGCATATGGTCACATGATCGGTCGAGCGTGTTTCAAAGTTTGCGCCTAG
>Rosalind_12
ATCGGTCGAA
>Rosalind_15
ATCGGTCGAGCGTGT

=output 
MVYIADKQHVASREAYGHMFKVCA
=end pod
