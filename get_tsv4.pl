#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get_columns.pl - choose columns from a table.

=head1 SYNOPSIS
    
  get_tsv4.pl [options]

  Options:
    -help            brief help message
    -man             full documentation


=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
        
    Prints the manual page and exits.
    
=back
    
=head1 DESCRIPTION
    
=head2 Get specified columns with column name.

  cat table.txt | get_tsv4.pl -kc 1 -kn mail_address -vc 2 -vn name > result.out

=cut

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
#use Set::IntSpan qw/grep_set map_set/;
#use Set::Scalar;
#use String::Strip;

use open ":utf8";
use open ":std";

main();

#
#-------------------------------------------------
#


sub main {
    my %opts = analyze_args();
    if (defined($opts{kc}) && defined($opts{kn}) && defined($opts{vc}) && defined($opts{vn})) {
        get_column($opts{kc}, $opts{kn}, $opts{vc}, $opts{vn});
    }
}


sub analyze_args {
    my %opts = ();
    my $result = GetOptions(\%opts, "help!", "man!", "kc=i", "kn=s", "vc=i", "vn=s") or pod2usage(2);
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );
    return %opts;
}

sub get_column {
    my $key_column = shift @_;
    my $key_name = shift @_;
    my $value_column = shift @_;
    my $value_name = shift @_;

    while (<>) {
        chomp;
        my @cols = split(/\t/, $_, -1);
        print join("\t", ($key_name, $cols[$key_column], $value_name, $cols[$value_column], "\n"));
    }
}

__END__

