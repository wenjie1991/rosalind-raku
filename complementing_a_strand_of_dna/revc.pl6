#!/usr/bin/env perl6

multi MAIN()
{
    my $dna=$*IN.lines;
    revc($dna).say;
}

sub revc($dna is copy){
    $dna = $dna.flip;
    return ($dna ~~ tr/TCGA/AGCT/).after;
}


multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Complementing a Strand of DNA
L<http://rosalind.info/problems/revc/>

=input 
AAAACCCGGT

=output 
ACCGGGTTTT
=end pod
