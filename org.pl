use strict;
use warnings;



package OrgPl::Utils;

sub trim($)
{
    my $s = shift;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s;
}

1;



package OrgPl::Tags;

use Exporter;
our @EXPORT_OK = qw(list_tags);

use Data::Dumper;

sub list_tags {
    my $filename = shift;
    my @collection = ();
    
    open(my $fh, $filename) or die "Could not open $filename: $!";
   
    while(my $line = <$fh>) {
        if ($line =~ m/^\#\+tags(\[\])?\:(.+)$/i) {
            my $matches = OrgPl::Utils::trim($2);
            my @tags = split /\s/, $matches;
            push @collection, @tags;
            # print Dumper(@tags), "\n";
        }
    }

    close $fh;

    # print Dumper(@collection), "\n";    
    return @collection;
}

sub get_title {
    my $filename = shift;
    my $result = '';
    
    open(my $fh, $filename) or die "Could not open $filename: $!";   
   
    while(my $line = <$fh>) {
        if ($line =~ m/^\#\+title\:(.+)$/i) {
            $result = OrgPl::Utils::trim($1);
            last;
        }
    }

    close $fh;
    
    return $result;
}


sub has_all {
    my ($tags, $subset) = @_;
    #print "Tags: ", Dumper($tags), "\n";
    #print "Subset: ", Dumper($subset), "\n";

    my $result = 1;

    foreach my $t (@$subset) {
        $result &&= scalar(grep { $_ eq $t } @$tags);
    }

    return $result != 0;
}

1;



package OrgPl::Find;

use Exporter;
our @EXPORT_OK = qw(find_contains_all_in);

use File::Find qw(find);

sub find_contains_all_in {
    die 'find_contains_all_in($dir, $tags_arr_ref)' if scalar @_ < 2;

    my ($dir, $tags_arr_ref) = @_;
    #print $dir, "\n";
    #print @$tags_arr_ref, "\n";

    find(sub{
        my $file = $File::Find::name;
        my @tags = OrgPl::Tags::list_tags($file);
        if (OrgPl::Tags::has_all(\@tags, $tags_arr_ref)){
            my $title = OrgPl::Tags::get_title($file);            
            print "[[file:$file]] :: $title\n";
        }        
         }, $dir);
}

1;


package ::main;

use Data::Dumper;

{
    die 'pls specify a mode in one of [find]' if scalar @ARGV < 1;

    my $mode = $ARGV[0];

    if ($mode eq 'find') {
        my $dir = $ARGV[1] or die("pls specify a dir!");
        my @tags = @ARGV[2..$#ARGV];                    
        OrgPl::Find::find_contains_all_in($dir, \@tags);
    } else {
        die "Unknown mode: $mode";
    }
}

# print Dumper(OrgPl::Tags::list_tags('/home/jhyun/P/simple-org-wiki/samples/no-sec-kws.org')), "\n";

=begin
{
    my @tags = OrgPl::Tags::list_tags('/home/jhyun/P/simple-org-wiki/samples/multiple-tags.org');
    print OrgPl::Tags::has_all(\@tags, ['tag_a', 'tag_b']);
}
=cut
