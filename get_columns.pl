#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get_columns.pl - choose columns from a table.

=head1 SYNOPSIS
    
  get_columns.pl [options]

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

=cut

use strict;
use Getopt::Long;
use Pod::Usage;
#use Set::IntSpan qw/grep_set map_set/;
#use Set::Scalar;
#use String::Strip;

use open ":utf8";
use open ":std";

main();

#
#-------------------------------------------------
#


sub main {
    my %opts = analyze_args();
    
    if (defined($opts{col})) {
		get_column($opts{col});
    }
}


sub analyze_args {
    my %opts = ();

    my $result = GetOptions(\%opts, "help!", "man!", "col=s") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


# sub tab_split {
#     my $line = shift @_;

#     $line =~ s/\t/\t /g;
#     my @a = split(/\t/, $line);
#     for (my $i=1; $i<=$#a; $i++) {
# 	$a[$i] = substr($a[$i], 1);
#     }
#     return @a;
# }



sub get_column {
    my $range = shift @_;

    while (<>) {
		chomp;
		#my @col = tab_split($_);
		my @col = split /\t/, $_;
		my @out = ();
		my @idx = getIdx($range, $#col);
		for (my $i=0; $i<=$#idx; $i++) {
			push @out, $col[$idx[$i]];
		}
		print join("\t", @out), "\n";
    }
}



sub getIdx {
	my ($range, $max) = @_;
	my @ret = ();
	my @block = split /,/, $range;
	foreach my $b (@block) {
		if ($b =~ /^([0-9]+)-\)?$/) {
			for (my $i=$1; $i<=$max; $i++) {
				push @ret, $i;
			}
		}
		elsif ($b =~ /^\(?\-([0-9]+)$/) {
			my $to = $1;
			for (my $i=0; $i<=$to; $i++) {
				push @ret, $i;
			}
		}
		else {
			my ($from, $to) = split /\-/, $b;
			if (!defined($to)) {
				push @ret, $from;
			}
			else {   
				for (my $i=$from; $i<=$to; $i++) {
					push @ret, $i;
				}
			}
		}
	}
	return @ret;
}



__END__

