#!/usr/bin/env perl6
#use Grammar::Tracer;

my $fasta = $*IN.slurp;

# fasta paser grammar
grammar FASTA::Grammar::DNA {
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


my @seqs = FASTA::Grammar::DNA.parse($fasta, actions => FASTA::Actions).made;

# GC content calculator
sub gc_content($seq) {
    $seq.comb.Bag{"C", "G"}.sum / $seq.chars;
}

# print result
my %gc = @seqs.map({$_<id> => gc_content($_<sequence>)});
%gc.maxpairs[0] ==> (-> $_ { say $_.keys[0]; say $_.values[0] * 100; })();
