#!/usr/bin/env perl6

multi MAIN() {
    my ($s, $t) = $*IN.lines[0, 1];
    ($s.comb Z $t.comb).map({!($_[0] eq $_[1])}).sum.say;
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Counting Point Mutations
L<http://rosalind.info/problems/hamm/>

=input 
GAGCCTACTAACGGGAT
CATCGTAATGACGGCCT

=output 
y
=end pod
