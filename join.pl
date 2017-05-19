#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Pod::Usage;

use open ":utf8";
use open ":std";

main();

#
#-------------------------------------------------
#

sub analyze_args {
    my %opts = (NA=>'\\N', target=>0, merge=>undef);

    my $result = GetOptions(\%opts, "help!", "man!", "target=i", "merge!", "NA=s") or pod2usage(2);

    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub main {
    my %opts = analyze_args();
	my $t = $opts{target};
	
	my ($joined_data, $nCoumns) = read_file(@ARGV);
	my %j = %$joined_data;
	my @NA = not_available($nCounts, $opts{NA});
	while (<STDIN>) {
		chomp;
		my @c = tab_split($_);
		if (defined($j{$c[$t]})) {
			my @matched = @$j{$c[$t]};
			for (my $i=0; $i<=$#matched; $i++) {
				print join("\t", @c), "\t", join("\t", @$matched[$i]), "\n";
			}
		}
		else {
			print join("\t", @c), "\t", join("\t", @NA), "\n";
		}
	}
}


sub read_file {
	my @files = @_;

	my %joined_data = ();
	my $nCounts = 0;
	for (my $i=0; $i<=$#files; $i++) {
		open(SESAME, $files[$i]);
		while (<SESAME>) {
			chomp;
			my @c = tab_split($_);

			if (!defined($joined_data{$c[0]})) {
				$joined_data{$c[0]} = ();
			}
			push $joined_data{$c[0]}, shift(@c);			
			$nCounts = $#c+1;
		}
	}
	return (\%joined_data, $nCounts);
}


sub not_available {
	my $n = shift @_;
	my $NA = shift @_;
	
	my @ret = ();
	for (my $i=0; $i<$n; $i++) {
		push @ret, $NA;
	}
	return @ret;
}


sub tab_split {
    my $line = shift @_;

    $line =~ s/\t/\t /g;
    my @a = split(/\t/, $line);
    for (my $i=1; $i<=$#a; $i++) {
	$a[$i] = substr($a[$i], 1);
    }
    return @a;
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
