#!/usr/bin/perl


use strict;
use Getopt::Long;
use Pod::Usage;

  
main();


sub parseCommandLine {
    my %opts = (debug=>0, test=>0);
    
    my $result = GetOptions(\%opts, "help!", "man!","c=i@") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );
        
    return %opts;
}


sub main {
    
    my %opts = parseCommandLine();

    while (<>) {
        my @r = ();
	chomp;
        my @c = split(/\t/, $_, -1);
        foreach my $i (@{$opts{c}}) {
            push @r, $c[$i];
        }
        print $c[0], "\t", join(";", @r), "\n";
    }
}

#
#-------------------------------------------------
#


#
#-------------------------------------------------
#


__END__


=pod

    
=head1 NAME
	
 merge_column.pl - A template of perl script.

=head1 SYNOPSIS
    
  00.plxx [options]

  Options:
    -help            brief help message
    -man             full documentation
    -test            invoking incremental test.

=head1 EXAMPLE

  # 
  cat data.txt | 00.plxx > result.out

  # invoking incremental test.
  00.plxx -test

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
