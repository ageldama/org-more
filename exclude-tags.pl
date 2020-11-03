use strict;
use warnings;

while(<>) {
    if (!($_ =~ m/^\#\+tags\[\]\:(.+)$/i)) {
        print $_;
    }
}
