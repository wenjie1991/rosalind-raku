#!/usr/bin/env perl6

multi MAIN() {
    my $dna = $*IN.lines;
    my @nucleic_acide = <A C G T>;
    my $dna_bag = $dna.comb.Bag;
    say @nucleic_acide.map({$dna_bag{$_}}).join(" ");
}

multi MAIN(Bool :$man!)
{
    run $*EXECUTABLE, '--doc', $*PROGRAM;
}

=begin pod
=head1 Description

=para
Counting DNA Nucleotides
L<http://rosalind.info/problems/dna/>

=head1 Example Input and Output

=head2 Input

=begin code
AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
=end code

=head2 Output

=begin code
20 12 17 21
=end code
=end pod

