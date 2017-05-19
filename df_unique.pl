#!/usr/bin/perl

use strict;
use Getopt::Long;
use Pod::Usage;

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


sub analyze_opts {
  my %opts;
  my $result = GetOptions(\%opts, "help!", "man!", "col=i") or pod2usage(2);
  pod2usage(1) if ($opts{help});
  pod2usage(-exitstatus=>0, -verbose=>2) if $opts{man};

  return %opts;
}


sub main {

  my %opts = analyze_opts();
  my %data = ();


  if (defined($opts{col})) {
    while (<STDIN>) {
      chomp;
      my $line = $_;
      my @col = tab_split($_);
      if ($data{$col[$opts{col}]} <= 0) {
		  print $line, "\n";
		  $data{$col[$opts{col}]}++;
      }
    }
  }
  else {
    while (<STDIN>) {
      chomp;
      if ($_ ne "") {
	  $data{$_}++;
      }
    }
    foreach my $key (keys %data) {
      print $key, "\n";
    }
  }
}




__END__

=head1 NAME

  df_unique.pl - get rows with unique values from a data frame.

=head1 SYNOPSYS

 cat datafile | df_unique.pl > result.data

 Options:
   -help      brief help message
   -man       full documentation

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

=cut
