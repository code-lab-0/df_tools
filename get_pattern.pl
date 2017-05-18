#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get_subpattern.plx - 

=head1 SYNOPSIS
    
  get_subpattern.plx [options]

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
    
=head2 Get specified columns

  cat table.txt | get.plx -col=0:2:3:7 > result.out
  cat table.txt | get.plx -col=0-3:7:10- > result.out

  cat table.txt | get.plx -cond="(@2 eq 'biological_process')"
  cat table.txt | get.plx -cond='[14:15]a(@==1)'

  # get lines from the top until the line which matches the pattern.
  cat text.txt  | get.plx -until="^the\s*pattern"
    
=cut

use strict;
use Getopt::Long;
use Pod::Usage;

main();

sub analyze_args {
    my %opts = (n=>10);

    my $result = GetOptions(\%opts, "help!", "man!",
			    "n=i",
                            "p=s",
                            "pattern=s") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    if (!defined($opts{pattern}) && defined($opts{p})) {
        $opts{pattern} = $opts{p};
      }
    
    return %opts;
}


sub main {
    my %opts = analyze_args();
   
    get_subpattern($opts{pattern}, $opts{n});
    
}


sub get_subpattern {
    my $pattern = shift @_;
    my $n       = shift @_;

    while (<>) {
	my @out = ();
	if (/$pattern/) {
	    if (defined($1) && $n >=1) {
		push @out, $1;
	    }
	    if (defined($2) && $n >=2 ) {
		push @out, $2;
	    }
	    if (defined($3) && $n >=3) {
		push @out, $3;
	    }
	    if (defined($4) && $n >=4) {
		push @out, $4;
	    }
	    if (defined($5) && $n >=5) {
		push @out, $5;
	    }
	    if (defined($6) && $n >=6) {
		push @out, $6;
	    }
	    if (defined($7) && $n >=7) {
		push @out, $7;
	    }
	    if (defined($8) && $n >=8) {
		push @out, $8;
	    }
	    if (defined($9) && $n >=9) {
		push @out, $9;
	    }

	    if ($#out >=0) {
		print join("\t", @out), "\n";
	    }
	}
    }
}
