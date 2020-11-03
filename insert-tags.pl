use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

die 'pls specify filename, line-num and tags!' if 2 > scalar @ARGV;

my $filename = $ARGV[0];
my $line_num = +$ARGV[1];
die "'$line_num' is not a number." unless looks_like_number($line_num);
# print "$filename @ $line_num\n";

my @tags = @ARGV[2..$#ARGV];
my $tags2 = join(' ', @tags);
# print "[$tags2]";

open(my $info, $filename) or die "Could not open $filename: $!";

my $line_count = 0;
while(my $line = <$info>) {
    if ($line_count == $line_num) {
        print "#+TAGS[]: $tags2\n";
    }
    print $line;
    $line_count ++;
}

close $info;

