#!/usr/bin/env perl6
use v6;

sub MAIN($input_string = "0.1 0.25 0.5") {
    my @p_aa = $input_string.split(" ")>>.Num;
    say @p_aa>>.&afrq.fmt('%.3g');
}

sub afrq($p_aa) { 
    my $p_least_one_ressesive = 1 - (1 - (sqrt $p_aa)) ** 2;
    return $p_least_one_ressesive;
}
