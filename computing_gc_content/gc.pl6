#!/usr/bin/env perl6
#use Grammar::Tracer;

# fasta paser grammar
grammar FASTA::Grammar {
    token TOP { <record>+ }

    token record { ">"<id><commnet>?"\n"<sequence> }

    token id { <-[\ \n]>+ }

    token comment { " "<-[\n]>+ }

    token sequence { <[ACGTRYKMSWBDHVNX\-\n]>+ }
}

class FASTA::Actions {
    method TOP ($/) { 
        make $<record>>>.made; 
    }

    method record ($/) {
        make {
            id => ~$<id>,
            comment => ($<comment>) ?? (~$<comment>).trim !! '',
            sequence => $<sequence>.subst("\n", '', :g)
        };
    }
}

multi MAIN() {
    my $fasta = $*IN.slurp;
    my @seqs = FASTA::Grammar::DNA.parse($fasta, actions => FASTA::Actions).made;

    # print result
    my %gc = @seqs.map({$_<id> => gc_content($_<sequence>)});
    %gc.maxpairs[0] ==> (-> $_ { say $_.keys[0]; say $_.values[0] * 100; })();
}

# GC content calculator
sub gc_content($seq) {
    $seq.comb.Bag{"C", "G"}.sum / $seq.chars;
}


multi MAIN(Bool :$man!) {
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}
=begin pod
=head1 Description

=para
Computing GC Content
L<http://rosalind.info/problems/gc/>

=input 
>Rosalind_6404
CCTGCGGAAGATCGGCACTAGAATAGCCAGAACCGTTTCTCTGAGGCTTCCGGCCTTCCC
TCCCACTAATAATTCTGAGG
>Rosalind_5959
CCATCGGTAGCGCATCCTTAGTCCAATTAAGTCCCTATCCAGGCGCTCCGCCGAAGGTCT
ATATCCATTTGTCAGCAGACACGC
>Rosalind_0808
CCACCCTCGTGGTATGGCTAGGCATTCAGGAACCGGAGAACGCTTCAGACCAGCCCGGAC
TGGGAACCTGCGGGCAGTAGGTGGAAT

=output
Rosalind_0808
60.919540
=end pod
