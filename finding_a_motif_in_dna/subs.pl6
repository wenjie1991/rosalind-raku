#!/usr/bin/env perl6

my ($ref, $query) = $*IN.lines[0, 1];
$ref ~~ m:ov/$query/;
@$/.map({$_.from + 1}).join(" ").say;
