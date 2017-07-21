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

=head1 Example Input and Output

=head2 Input

=begin code
GATGGAACTTGACTACGTAAATT
=end code

=head2 Output

=begin code
GAUGGAACUUGACUACGUAAAUU
=end code
=end pod

