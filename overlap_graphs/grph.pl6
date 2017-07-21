#!/usr/bin/env perl6

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

multi MAIN() {
    my $fasta = $*IN.slurp;
    my @seqs = FASTA::Grammar::DNA.parse($fasta, actions => FASTA::Actions).made;

    for (@seqs X @seqs).flat -> $a, $b {
        next if $a === $b;
        say [$a<id>, $b<id>].join(" ")  if $a<sequence>.substr(*-3) eq $b<sequence>.reverse.substr(0, 3)
    }
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Overlap Graphs
L<http://rosalind.info/problems/grph/>

=head1 Example Input and Output

=head2 Input

=begin code
>Rosalind_0498
AAATAAA
>Rosalind_2391
AAATTTT
>Rosalind_2323
TTTTCCC
>Rosalind_0442
AAATCCC
>Rosalind_5013
GGGTGGG
=end code

=head2 Output

=begin code

Rosalind_0498 Rosalind_2391
Rosalind_0498 Rosalind_0442
Rosalind_2391 Rosalind_2323
=end code
=end pod

