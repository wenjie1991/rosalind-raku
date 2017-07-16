#!/usr/bin/env perl6

#use Grammar::Tracer;

#my $ids = Q:to/END/;
#A2Z669
#B5ZC00
#P07204_TRBM_HUMAN
#P20840_SAG1_YEAST
#END
my $ids = $*IN.slurp;

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


my @ids = $ids.words;
sub get_protein_sequence($id) {
    my $url = 'http://www.uniprot.org/uniprot/' ~ $id ~ '.fasta';
    return shell("curl -L $url 2>/dev/null", :out).out.slurp;
}
my $htmls = @ids.map({get_protein_sequence($_)}).join();


my @seqs = FASTA::Grammar::Protein.parse($htmls, actions => FASTA::Actions).made;
for @seqs.keys -> $i {
    @seqs[$i]<id> = @ids[$i];
}

# motif: N{P}[ST]{P}
my regex motif { N<-[P]><[ST]><-[P]> };
@seqs.map(&(-> $seq {
    my @from  = ($seq<sequence> ~~ m:overlap/<motif>/)>>.from;
    if @from {
        say $seq<id>;
        say @from.map(* + 1).join(" ");
    }
}));



