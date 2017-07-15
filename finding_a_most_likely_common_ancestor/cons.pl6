#!/usr/bin/env perl6

#my $fasta = q:to/END/;
#>Rosalind_1
#ATCCAGCT
#>Rosalind_2
#GGGCAACT
#>Rosalind_3
#ATGGATCT
#>Rosalind_4
#AAGCAACC
#>Rosalind_5
#TTGGAACT
#>Rosalind_6
#ATGCCATT
#>Rosalind_7
#ATGGCACT
#END
my $fasta = $*IN.slurp;

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

my @seqs = FASTA::Grammar::DNA.parse($fasta, actions => FASTA::Actions).made;

my $n = @seqs[0]<sequence>.chars;
my %matrix = <A C G T>.map({$_ => [0 xx $n]});

for @seqs -> $seq {
    %matrix = add_profile_matrix($seq<sequence>, %matrix);
}

## Output:
say extract_consensus(%matrix).join;
%matrix.map({say [$_.key~":", $_.value].join(" ")});


## Subs
sub extract_consensus(%matrix){
    my @consensus_string;
    my @consensus_max_count;

    for %matrix.kv -> $k, $v {
        for $v.cache.pairs -> $p {
            if (!@consensus_string[$p.key]) {
                @consensus_max_count[$p.key] = $p.value;
                @consensus_string[$p.key] = $k;
            } elsif (@consensus_max_count[$p.key] < $p.value) {
                @consensus_max_count[$p.key] = $p.value;
                @consensus_string[$p.key] = $k;
            } else {
                @consensus_string[$p.key] = @consensus_string[$p.key];
            }
        }
    }
    return @consensus_string;
}

sub add_profile_matrix($seq, %matrix is copy) {
    $seq.comb.pairs.map({
        %matrix{$_.value}[$_.key]++;
    });
    return %matrix;
}


