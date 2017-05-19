#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get_subpattern.pl - get subexpressions in the tab delimited format.

=head1 SYNOPSIS
    
  get_subpattern.pl [options]

  Options:
    -help            brief help message.
    -man             full documentation.

	-p               regular expression.


=head1 Example

  cat yourfile | get_subpattern.pl -p='^(.+?):(.+?);(.+)'

=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
        
    Prints the manual page and exits.
    
=back
    
=head1 DESCRIPTION
    
=head2 Get specified columns
    


=cut

use strict;
use Getopt::Long;
use Pod::Usage;

main();


sub main {
    my %opts = analyze_args();
   
    get_subpatterns($opts{pattern}, $opts{n});
    
}


sub analyze_args {
    my %opts = (n=>10);

    my $result = GetOptions(\%opts, "help!", "man!",
							"n=i@", "p=s") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}



sub get_subpatterns {
    my $pattern = shift @_;
    #my $n       = 10;

    while (<>) {
		my @out = ();
		if (/$pattern/) {
			if (defined($1)) {
				push @out, $1;
			}
			if (defined($2)) {
				push @out, $2;
			}
			if (defined($3)) {
				push @out, $3;
			}
			if (defined($4)) {
				push @out, $4;
			}
			if (defined($5)) {
				push @out, $5;
			}
			if (defined($6)) {
				push @out, $6;
			}
			if (defined($7)) {
				push @out, $7;
			}
			if (defined($8)) {
				push @out, $8;
			}
			if (defined($9)) {
				push @out, $9;
			}

			if ($#out >=0) {
				print join("\t", @out), "\n";
			}
		}
    }
}
