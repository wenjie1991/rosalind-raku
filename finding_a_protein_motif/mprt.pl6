#!/usr/bin/env perl6
#use Grammar::Tracer;


grammar FASTA::Grammar::Protein {
    token TOP { <record>+ }
    token record { ">"<id><comment>?"\n"<sequence> }
    token id { <-[\ \n]>+ }
    token comment { " "<-[\n]>+ }
    token sequence { <[A..Z\*\-\n]>+ }
}

class FASTA::Actions {
    method TOP ($/) {
        make $<record>>>.made;
    }
    method record ($/) {
        make {
            id => ~$<id>,
            comment => ($<comment>) ?? (~$<comment>).trim !! '',
            sequence => $<sequence>.subst("\n", "", :g)
        };
    }
}

multi MAIN() {
    my $ids = $*IN.slurp;
    my @ids = $ids.words;
    my $htmls = @ids.map({get_protein_sequence($_)}).join();
    my @seqs = FASTA::Grammar::Protein.parse($htmls, actions => FASTA::Actions).made;
    my regex motif { N<-[P]><[ST]><-[P]> }; # motif: N{P}[ST]{P}

    for @seqs.keys -> $i {
        @seqs[$i]<id> = @ids[$i];
    }

    @seqs.map(&(-> $seq {
        my @from  = ($seq<sequence> ~~ m:overlap/<motif>/)>>.from;
        if @from {
            say $seq<id>;
            say @from.map(* + 1).join(" ");
        }
    }));
}


sub get_protein_sequence($id) {
    my $url = 'http://www.uniprot.org/uniprot/' ~ $id ~ '.fasta';
    return shell("curl -L $url 2>/dev/null", :out).out.slurp;
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Finding a Protein Motif
L<http://rosalind.info/problems/mprt/>

=head1 Example Input and Output

=head2 Input

=begin code
A2Z669
B5ZC00
P07204_TRBM_HUMAN
P20840_SAG1_YEAST
=end code

=head2 Output

=begin code
B5ZC00
85 118 142 306 395
P07204_TRBM_HUMAN
47 115 116 382 409
P20840_SAG1_YEAST
79 109 135 248 306 348 364 402 485 501 614
=end code
=end pod

