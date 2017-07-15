#!/usr/bin/env perl6

use NativeCall;

constant LIBPATH="$*CWD/strstr";

sub strstr(Str, Str) returns Str is native(LIBPATH) is symbol('find_str_in_str') { * };

say "yes" if strstr("abcde", "abcd");


