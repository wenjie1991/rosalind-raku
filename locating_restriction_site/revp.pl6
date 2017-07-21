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

    sub revc($dna is copy){
        $dna = $dna.flip;
        ($dna ~~ tr/TCGA/AGCT/).join;
    }

    my @mer = 4,6...12;
    for @mer -> $length {
        (0..($dna.chars - $length)).map({
            my $kmer = $dna.substr($_, $length);
            if $kmer eq revc($kmer) {
                say [$_ + 1, $length].join(" ");
            }
        });
    }
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Locating Restriction Sites
L<http://rosalind.info/problems/revp/>

=head1 Example Input and Output

=head2 Input

=begin code
>Rosalind_24
TCAATGCATGCGGGTCTATATGCAT
=end code

=head2 Output

=begin code
4 6
5 4
6 6
7 4
17 4
18 4
20 6
21 4
=end code
=end pod

