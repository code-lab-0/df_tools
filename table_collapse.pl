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


sub parseCommandLine {
    my %opts = (debug=>0, test=>0, delim=>"; ");
    
    my $result = GetOptions(\%opts, "help!", "man!",
			    "col=i", "delim=s") or pod2usage(2);
    
    
    pod2usage(1) if ($opts{help} || !defined($opts{col}));
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );
    
    
    return %opts;
}


sub main {
    
    my %opts = parseCommandLine();
    
    my $col = $opts{col};
    my %data = ();
    
    while (<>) {
	chomp;
	my @c = tab_split($_);

	my $item  = '';
	my @key1  = ();
	my @key2  = ();
	my $key   = '';
	my $value = '';
	my $flg   = 0;
	for (my $i=0; $i<=$#c; $i++) {
	    if ($i == $col) {
		$item = $c[$i];
		$flg  = 1;
	    }
	    elsif ($flg == 0) {
		push @key1, $c[$i];
	    }
	    elsif ($flg > 0) {
		push @key2, $c[$i];
	    }	       
	}
	my $key = join("\t", @key1) . "\n" . join("\t", @key2);
	push @{ $data{$key} }, $item; 
    }


    foreach my $key (keys %data) {
	my ($k1, $k2) = split /\n/, $key;
	my @key1 = tab_split($k1);
	my @key2 = tab_split($k2);
	my @val  = sort @{ $data{$key} };
	my $val  = join($opts{delim}, @val);
	print join("\t", @key1, $val, @key2), "\n";
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
