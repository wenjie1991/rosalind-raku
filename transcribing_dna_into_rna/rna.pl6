#!/usr/bin/env perl6

multi MAIN() {
    my $dna = $*IN.lines;
    $dna.subst("T", "U", :g).say for @$dna;
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Transcribing DNA into RNA
L<http://rosalind.info/problems/rna/>

=input 
GATGGAACTTGACTACGTAAATT

=output 
GAUGGAACUUGACUACGUAAAUU
=end pod
