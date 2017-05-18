#!/usr/bin/perl


=pod
    
=head1 NAME
	
 substitute.plx - substitute input line using a pattern.

=head1 SYNOPSIS
    
  cat list.txt | substitute.plx -pattern=output

  Options:
    -help            brief help message
    -man             full documentation
    -output          A pattern of outputted lines.

=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
    
    
    Prints the manual page and exits.
    
=back
    
=head1 DESCRIPTION
    
    B<This program> will read the given input file(s) and do someting
    useful with the contents thereof.
    
=cut
    

use strict;
use File::Basename;
use Getopt::Long;
use Pod::Usage;

main();


sub analyze_args {
  my %opts = (obj=>'all');
  GetOptions(\%opts, "help", "man",
	     "output=s") or pod2usage(2);
  pod2usage(1) if ( $opts{help});
  pod2usage(-exitstatus=>0, -verbose=>2) if ($opts{man});

  return %opts;
}


sub main {

  my %opts = analyze_args();

  while (<STDIN>) {
    chomp;
    print substitute($opts{output}, $_), "\n";
  }
}



#-----------------------------------------------------------

sub substitute {
  my ($pattern, $fname) = @_;
  
  my ($base,$dir,$ext) = fileparse($fname, '\..*');

  $pattern =~ s/\@BASE/$base/g;
  $pattern =~ s/\@DIR/$dir/g;
  $pattern =~ s/\@EXT/$ext/g;
  $pattern =~ s/\@FILE/$fname/g;
  $pattern =~ s/\@NAME/$fname/g;
  
  return $pattern;
}
