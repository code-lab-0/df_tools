#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get.plx - get selected rows or columns from a table.

=head1 SYNOPSIS
    
  get.plx [options]

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
use Set::IntSpan qw/grep_set map_set/;
use Set::Scalar;

main();


#
#-------------------------------------------------
#

sub tab_split {
    my $line = shift @_;

    $line =~ s/\t/\t /g;
    my @a = split(/\t/, $line);
    for (my $i=1; $i<=$#a; $i++) {
	$a[$i] = substr($a[$i], 1);
    }
    return @a;
}


sub analyze_args {
    my %opts = (exclude=>undef);

    my $result = GetOptions(\%opts, "help!", "man!",
			    "cond=s",
			    "exclude!") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub main {
    my %opts = analyze_args();
    my $cond = $opts{cond};
    
    my $flg = 0;
    my $expr;
    my $com;
    
    if ($cond =~ /\((.+)\)/) {
	$expr = $1;
    }

    if (defined($expr)) {
	$com = "if ($expr) { return 1;} else { return undef; }";
    }

    while (<STDIN>) {
	chomp;
	my $line = $_;
	my @c = tab_split($_);

	if ($flg > 0) {
	    print $line, "\n";
	}
	elsif (eval $com) {
	    $flg = 1;
	    if (!$opts{exclude}) {
		print $line, "\n";
	    }
	}
	
    }   
    
}




__END__

