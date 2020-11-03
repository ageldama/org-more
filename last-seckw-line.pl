use strict;
use warnings;

my $line = 0;

while(<>) {
    if ($_ =~ m/^\#\+.+\:(.+)$/i) {
        $line ++;
    }
}

print $line;
