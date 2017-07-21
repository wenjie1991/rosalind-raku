#!/usr/bin/env perl6

multi MAIN() {
    my ($k, $m, $n) = $*IN.lines[0].words;
    my $s = $k + $m + $n;


    (($k/$s * ($k-1)/($s-1)) +  # k x k
    ($k/$s * $m/($s-1) * 2) +  # k x m
    ($k/$s * $n/($s-1) * 2) +  # k x n
    ($m/$s * ($m-1)/($s-1) * 2 * 3/4 / 2) +  # m x m 
    ($m/$s * $n/($s-1) * 2 / 2)).say;  # m x n
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Mendel's First Law
L<http://rosalind.info/problems/iprb/>

=input 
2 2 2

=output 
0.78333
=end pod
