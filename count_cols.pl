#!/usr/bin/perl

=pod
    
=head1 NAME
	
 count_cols.pl -- Count number of columns of each row.

=head1 SYNOPSIS
    
  count_cols.pl your-file.tsv

  Options:
    -help            brief help message
    -man             full documentation

=cut

use strict;
use Getopt::Long;
use Pod::Usage;

use open ":utf8";
use open ":std";

main();

#
#-------------------------------------------------
#


sub main {
	my %opts = analyze_args();
	count_cols();
}


sub analyze_args {
    my %opts = ();

    my $result = GetOptions(\%opts, "help!", "man!") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub count_cols {

    while (<>) {
		chomp;
		my @col = split("\t", $_, -1);
		my @out = ();

		my $count = $#col + 1;
		print $count, "\n";
    }
}


__END__

