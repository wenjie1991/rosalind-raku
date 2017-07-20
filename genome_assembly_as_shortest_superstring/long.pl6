#!/usr/bin/env perl6

#my $fasta = Q:to/END/;
#>Rosalind_56
#ATTAGACCTG
#>Rosalind_57
#CCTGCCGGAA
#>Rosalind_58
#AGACCTGCCG
#>Rosalind_59
#GCCGGAATAC
#END

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

my @seqs = FASTA::Grammar.parse($fasta, actions => FASTA::Actions).made; #.map({$_<sequence>});
my %seqs = @seqs.race.map({$_<id> => $_<sequence>});

my @chain_table;
for (%seqs X %seqs).flat -> $a, $b {
    next if $a.keys eq $b.keys; my $string_a = $a.value;
    my $string_b = $b.value;
    my $length_a = $string_a.chars;
    my $length_b = $string_b.chars;
    my $seq_min_length = min($length_a, $length_b);
    my $match_search_scope_begin = $seq_min_length;
    my $match_search_scope_end = ($seq_min_length / 2).floor;
    my $unmatch_string_length;
    unless $string_a.contains($string_b.reverse.substr(0, $match_search_scope_end)) {
        next;
    }
    for $match_search_scope_begin...$match_search_scope_end -> $match_length {
        if $string_a.substr(*-$match_length) eq $string_b.reverse.substr(0, $match_length) {
            $unmatch_string_length = $length_a + $length_b - $match_length;
            @chain_table.push({start => $a.key, end => $b.key, unmatch => $unmatch_string_length, match => $match_length});
            last;
        }
    }
}

my $superstring = "";
my $start_id;
my $end_id;
my $match_length;
my $start_string;
my $end_string;
while (@chain_table) {
    my %current_edge = @chain_table.shift;
    if ($superstring eq "") {
        $start_id = %current_edge<start>;
        $end_id = %current_edge<end>;
        $match_length = %current_edge<match>;
        $start_string = %seqs{$start_id};
        $end_string = %seqs{$end_id};
        $superstring = $start_string ~ $end_string.substr($match_length);
    } else {
        if (%current_edge<start> eq $end_id) {
            $end_id = %current_edge<end>;
            $match_length = %current_edge<match>;
            $start_string = $superstring;
            $end_string = %seqs{$end_id};
            $superstring = $start_string ~ $end_string.substr($match_length);
        } elsif (%current_edge<end> eq $start_id) {
            $start_id = %current_edge<start>;
            $match_length = %current_edge<match>;
            $start_string = %seqs{$start_id};
            $end_string = $superstring;
            $superstring = $start_string ~ $end_string.substr($match_length);
        } else {
            @chain_table.push(%current_edge);
        }
    }
}

say $superstring;
