#!/usr/bin/env perl 

open (G, $ARGV[0]) or die ('ERROR: fasta file not found \n'); 
while (<G>) {
    chomp;
    if (/\>(.*)/) {
        $name = $1;
    } else {
        $seq{$name} = $seq{$name}.$_; 
    }       
}
for ($i=0; $i<length($seq{$name}); $i++) {
    $flag = 1; 
    $j = 0;
    while ($flag && ($j+$i)<length($seq{$name})) {
        $j++;
        $motif = substr $seq{$name}, $i, $j;
        foreach (keys(%seq)) {
            if ($seq{$_} !~ /$motif/) {$flag=0;}
        }
        if ($flag==1 && length($max)<length($motif)) {
            $max = $motif;
        }
    }
}
print $max;
