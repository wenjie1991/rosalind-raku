use v6;

my $default-input = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC";

sub MAIN($input = $default-input) {
    my @four-dna = "A","C","G","T";
    my $four-dna = <A C G T>;
    say $four-dna.WHAT;
    say +@four-dna;
    "{@four-dna}".say;
    say @four-dna.join("\t");
    "{<A C G T>.map({ +$input.comb(/$_/) })}".say;
    say "{bag($input.comb)<A C G T>}";
}
