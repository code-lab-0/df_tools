#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use open ":utf8";
use open ":std";

&main;

sub main {
    my %opts = analyze_args();
    if ($opts{group}) {
        &get_group;
    } elsif ($opts{member}) {
        &get_member;
    } else {
        print "usage: parse_quota.pl --group|--member < input > output\n";
    }
}

sub analyze_args {
    my %opts = ( group => 0, member => 0 );
    Getopt::Long::GetOptions(\%opts, qw( group member )) or exit 1;
    return %opts;
}



sub get_group {
    my $group_line = 1;
    while (<>) {
        chomp;
        if ($group_line) {
            my @cols = split(/\t/, $_, -1);
            print join("\t", ($cols[0], $cols[1], $cols[2], $cols[3])), "\n";
            $group_line = 0;
            next;
        } else {
            if (/^\t/) {
                $group_line = 1;
                next;
            }
        }
    }
}

sub get_member {
    my $group_line = 1;
    my $group_id;
    while (<>) {
        chomp;
        if ($group_line) {
            my @cols = split(/\t/, $_, -1);
            $group_id = $cols[0];
            $group_line = 0;
            next;
        } else {
            if (/^\t/) {
                $group_line = 1;
                next;
            } else {
                my @cols = split(/\t/, $_, -1);
                print join("\t", ($cols[0], $group_id, $cols[1], $cols[2], $cols[3])), "\n";
                next;
            }
        }
    }
}
