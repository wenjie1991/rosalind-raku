#!/usr/bin/env perl6

multi MAIN() {

    my $rna = $*IN.lines>>.chomp.join;

    ## prepare codon table
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


    ## transcription
    sub transcript($rna) {
        my Str $peptides;
        for ($rna ~~ m:g/.../)>>.Str -> $code {
            my $aa = %rna_codon_table{$code};
            if ($aa eq "Stop") {
                last;
            }  else {
                $peptides ~= $aa;
            }
        }
        return $peptides;
    }

    say transcript($rna);
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Translating RNA into Protein
L<http://rosalind.info/problems/prot/>

=input 
AUGGCCAUGGCGCCCAGAACUGAGAUCAAUAGUACCCGUAUUAACGGGUGA

=output 
MAMAPRTEINSTRING
=end pod
