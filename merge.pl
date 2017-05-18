#!/usr/bin/perl

use strict;
use Getopt::Long;
use Pod::Usage;
use Set::Scalar;

my $NA = '\\N';

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


sub parseCommandLine {
    my %opts = (NA=>'\\N', other=>undef);
    
    my $result = GetOptions(\%opts, "help!", "man!",
			    "col=i", "values=s", "NA=s", "other=s") or pod2usage(2);

    $NA = $opts{NA};
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );
    
    
    return %opts;
}


sub main {
    
    my %opts = parseCommandLine();
    
    my @prec = split(/,/, $opts{values}); 
    my %data = ();
    while (<>) {
	chomp;
	my @c = tab_split($_);
	

	my $line = join("\t", @c);
	push @{ $data{$c[0]} }, [ $c[$opts{col}], $line ];
    }
    
  LOOP: foreach my $id (sort keys %data) {
      my $flg = 0;
      for (my $i=0; $i<=$#prec; $i++) {
	  foreach my $a (@{ $data{$id} }) {
	      if ($a->[0] eq $prec[$i]) {
		  print $a->[1], "\n";
		  $flg = 1;
	      }
	  }
	  if ($flg > 0) {
	      next LOOP;
	  }
      }


      if (defined($opts{other})) {
	  foreach my $a (@{ $data{$id} }) {
	      my $l = $a->[1];
	      my @c = tab_split($l);
	      $c[$opts{col}] = $opts{other};
	      print join("\t", @c), "\n";
	  }	  
      }
      else {
	  foreach my $a (@{ $data{$id} }) {
	      print $a->[1], "\n";
	  }
      }

  }
    
}




#
#-------------------------------------------------
#


__END__


=pod

    
=head1 NAME
	
 00.plx - A template of perl script.

=head1 SYNOPSIS
    
  00.plx [options]

  Options:
    -help            brief help message
    -man             full documentation
    -test            invoking incremental test.

=head1 EXAMPLE

  # 
  cat data.txt | 00.plx > result.out

  # invoking incremental test.
  00.plx -test

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
