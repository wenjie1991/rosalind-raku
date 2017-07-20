#!/usr/bin/env perl6

my $fasta = $*IN.slurp;

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

my @seqs = FASTA::Grammar.parse($fasta, actions => FASTA::Actions).made.map({$_<sequence>});
my $dna = @seqs[0];
#my $dna = "TCAATGCATGCGGGTCTATATGCAT";

sub revc($dna is copy){
    $dna = $dna.flip;
    ($dna ~~ tr/TCGA/AGCT/).join;
}

my $match = $dna ~~ m:overlap/$<restriction_site> = ((.**2..6)<{revc($0)}>)/;
my $start = $match>>.<restriction_site>>>.from.map(* + 1);
my $length = $match>>.<restriction_site>.map({$_.pos - $_.from});
for $start.Array Z $length.Array -> $a {
    say $a.join(" ");
}
