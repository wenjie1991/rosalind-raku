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
    my $dna = @seqs[0];

    my $rna-f = $dna.subst("T", "U", :g);
    my $rna-r = revc($dna).subst("T", "U", :g);

    my @peptides = (find_orf($rna-f), find_orf($rna-r)).flat;
    @peptides = @peptides.map({$_ if $_ !~~ /\-$/});

    say @peptides.unique.join("\n");
}


sub find_orf(Str $rna) {

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
    my @starts = ($rna ~~ m:overlap/AUG/)>>.from;
#    return gather (take transcript($rna.substr($_)) for @starts);
    return gather take transcript($rna.substr($_)) for @starts;
}

sub revc($dna is copy){
    $dna = $dna.flip.trim;
    ($dna ~~ tr/TCGA/AGCT/).join;
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Open Reading Frames
L<http://rosalind.info/problems/orf/>

=head1 Example Input and Output

=head2 Input

=begin code
>Rosalind_99
AGCCATGTAGCTAACTCAGGTTACATGGGGATGACCCCGCGACTTGGATTAGAGTCTCTTTTGGAATAAGCCTGAATGATCCGAGTAGCATCTCAG
=end code

=head2 Output

=begin code
MLLGSFRLIPKETLIQVAGSSPCNLS
M
MGMTPRLGLESLLE
MTPRLGLESLLE
=end code
=end pod

