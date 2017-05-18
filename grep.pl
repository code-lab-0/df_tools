#!/usr/bin/perl

=pod
    
=head1 NAME
	
 grep.plx - grep with Perl regular expression.

=head1 SYNOPSIS
    
  grep.plx [options] pattern filename

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
    
    grep.plx '\w+\[' filename.txt
    
=cut


use strict;
use Getopt::Long;
use Pod::Usage;


main();


sub analyze_args {
    my %opts = (not=>0);

    my $result = GetOptions(\%opts, "help!", "man!") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub main {
  my %opts = analyze_args();

  my $pattern = $ARGV[0];
  if (defined($ARGV[1])) {
      open(SESAME, $ARGV[1]);
      while (<SESAME>) {
	  if (/$pattern/) {
	      print $_;
	  }
      }
  }
  else {
      while (<STDIN>) {
	  if (/$pattern/) {
	      print $_;
	  }
      }
  }
  
}



__END__

