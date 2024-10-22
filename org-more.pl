#!/usr/bin/env perl
use strict;
use warnings;



package Org::More::Utils;

sub trim($)
{
    my $s = shift;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s;
}

1;



package Org::More::Tags;

use Exporter;
our @EXPORT_OK = qw(list_tags);

use Data::Dumper;
use Carp;

sub list_tags {
    my $filename = shift;
    my @collection = ();
    
    open(my $fh, $filename) or carp "Could not open $filename: $!";
   
    while(my $line = <$fh>) {
        if ($line =~ m/^\#\+tags(\[\])?\:(.+)$/i) {
            my $matches = Org::More::Utils::trim($2);
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
            $result = Org::More::Utils::trim($1);
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



package Org::More::Find;

use Exporter;
our @EXPORT_OK = qw(find_contains_all_in);

use File::Find qw(find);

sub find_contains_all_in {
    die 'find_contains_all_in($dir, $tags_arr_ref)' if scalar @_ < 2;

    my ($dir, $tags_arr_ref) = @_;
    #print $dir, "\n";
    #print @$tags_arr_ref, "\n";

    find(sub{
        # TODO skip `.git/**`?
        # only `.org` files
        if (!($_ =~ m/\.org$/)) {
            return;
        }
        #print "[$File::Find::name]\n";                        
        #
        my $file = $File::Find::name;
        my @tags = Org::More::Tags::list_tags($file);
        if (Org::More::Tags::has_all(\@tags, $tags_arr_ref)){
            my $title = Org::More::Tags::get_title($file);            
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
        Org::More::Find::find_contains_all_in($dir, \@tags);
    } else {
        die "Unknown mode: $mode";
    }
}

