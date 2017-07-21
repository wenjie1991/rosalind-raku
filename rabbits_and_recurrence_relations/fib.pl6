#!/usr/bin/env perl6

multi MAIN() {
    my ($month, $productivity) = $*IN.lines[0].words;
# $a: the pair has productivity in last month;
# $b: the pair in last month
    my $seq = (1,1,-> $a, $b { $a * $productivity + $b } ... *);
    $seq[$month - 1].say;
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Rabbits and Recurrence Relations
L<http://rosalind.info/problems/fib/>

=input 
5 3

=output 
19
=end pod
