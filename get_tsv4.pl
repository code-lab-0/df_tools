#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get_tsv4.pl - choose columns from a table.

=head1 SYNOPSIS
    
  get_tsv4.pl [options]

  Options:
    -help            brief help message
    -man             full documentation
    -kc              column number of key
    -kn              column name of key
    -vc              column number of value
    -vn              column name of value


=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
        
    Prints the manual page and exits.

=item B<-kc>
        
=back
    
=head1 DESCRIPTION
    
=head2 Get specified columns with column name.

  cat table.txt | get_tsv4.pl -kc 1 -kn mail_address -vc 2 -vn name > result.out

    or

  cat table.txt | get_tsv4.pl -kc 1 -vc 2 > result.out

=cut

use strict;
use warnings;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use utf8;
use Encode;
use Encode::Argv ('utf8');
use open ':encoding(utf8)';
use open ':std';

main();

#
#-------------------------------------------------
#

sub main {
    my %opts = analyze_args();
    if (defined($opts{kc}) and defined($opts{kn}) and defined($opts{vc}) and defined($opts{vn})) {
        &get_column4($opts{kc}, $opts{kn}, $opts{vc}, $opts{vn});
    } elsif (defined($opts{kc}) and defined($opts{vc})) {
        &get_column2($opts{kc}, $opts{vc});
    } else {
        pod2usage(2);
    }
}

sub analyze_args {
    my %opts = ();
    pod2usage(2) if $#ARGV == -1;
    GetOptions(\%opts, "help!", "man!", "kc=i", "kn=s", "vc=i", "vn=s");
    pod2usage(1) if $opts{help};
    pod2usage(-exitstatus=>0, -verbose=>2) if $opts{man};
    return %opts;
}

sub get_column4 {
    my $key_column = shift @_;
    my $key_name = shift @_;
    my $value_column = shift @_;
    my $value_name = shift @_;
    while (<>) {
        chomp;
        my @cols = split(/\t/, $_, -1);
        print(join("\t", ($key_name, $cols[$key_column], $value_name, $cols[$value_column])) . "\n");
    }
}

sub get_column2 {
    my $key_column = shift @_;
    my $value_column = shift @_;
    while (<>) {
        chomp;
        my @cols = split(/\t/, $_, -1);
        print(join("\t", ($cols[$key_column], $cols[$value_column])) . "\n");
    }
}
__END__

