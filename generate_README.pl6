#!/usr/bin/env perl6
my @rosalind_dirs = dir("./").map({$_ if $_.IO.d});
my @work_dir = @rosalind_dirs;
for @work_dir -> $work_dir {
    my @pl6script = dir($work_dir).map({$_ if $_ ~~ /pl6$/});
    for @pl6script -> $pl6script {
        my @lines = $pl6script.IO.lines;
        if @lines.map({$_ if $_ ~~ /\=begin\spod/})[0] {
            generate_readme($pl6script, $work_dir);
        };
    }
}

sub generate_readme($pl6script, $work_dir) {
    qqx[perl6 --doc=Markdown {$pl6script} > {$work_dir}/README.md];
}
