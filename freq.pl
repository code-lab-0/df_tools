#!/usr/bin/perl

use strict;
use Getopt::Long;
use Pod::Usage;

main();


#
#-------------------------------------------------
#

# TAB文字の連続に対応するってことか...
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
    my %opts = (comment=>1);
    my $result = GetOptions(\%opts, "help!", "man!", "col=s", "comment!","progress!") or pod2usage(2);
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if $opts{man};
    
    return %opts;
}


sub main {
    my %opts = analyze_opts();
    my %data = ();
    my %freq = ();

    if ($opts{comment}) {
	print '# ', join("\t", "occurence", "category"), "\n";
    }

    
    if (defined($opts{col})) {
    
	my @targets = split /:/, $opts{col};
	
	while (<>) {
	    chomp;
	    my @col = tab_split($_);

	    my $key = '';
	    my @keys;
	    my $counter = 0;
	    foreach my $t (@targets) {
		push @keys, $col[$t];
		#if ($counter++ % 10000 == 0) {
		#    print STDERR ".";
		#}
	    }
	    $key = join(":", @keys);
	    $data{$key}++;
	}
	
	
	foreach my $key (sort keys %data) {
	    my @k = tab_split($key);
	    print join("\t", $data{$key}, @k), "\n"; 
	}
    }
    else {

	while (<STDIN>) {
	    chomp;
	    my $key = $_;
	    
	    $data{$key}++;
	}
		
	foreach my $key (sort keys %data) {
	    print join("\t", $data{$key}, $key), "\n"; 
	}

    }
}


__END__

=head1 NAME

 freq.plx - Count each frequencies of differing elements.

=head1 SYNOPSYS

 cat data.txt | freq.plx 

 Options:
   -help      brief help message
   -man       full documentation
   -col       column ID

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

=cut
