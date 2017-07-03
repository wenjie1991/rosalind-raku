#!/usr/bin/env perl6
use v6;

sub MAIN($n = 6, $m = 3) {
    my $sum = my $C = ([*] $n-$m+1 .. $n) div [*] 1 .. $m;
    for $m+1 .. $n -> $k {
        $sum += $C = $C * ($n - $k + 1) div $k;
    }
    say $sum % 1_000_000;
}

