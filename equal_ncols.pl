#!/usr/bin/perl

=pod
    
=head1 NAME
	
 equal_ncols.pl -- Make number of columns of every row the same. 

=head1 SYNOPSIS
    
  equal_ncols.pl -ncol=10 your-file.tsv

  Options:
    -ncols           number of columns
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
    
    if (defined($opts{ncols})) {
		equal_ncols($opts{ncols});
    }
}


sub analyze_args {
    my %opts = ();

    my $result = GetOptions(\%opts, "help!", "man!", "ncols=i") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub equal_ncols {
    my $ncol = shift @_;

    while (<>) {
		chomp;
		my @col = split("\t", $_, -1);
		my @out = ();

		for (my $i=0; $i<$ncol; $i++) {
			if ($i<=$#col) {
				push @out, $col[$i];
			}
			else {
				push @out, "";
			}
		}
		
		print join("\t", @out), "\n";
    }
}


__END__

