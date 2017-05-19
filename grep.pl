#!/usr/bin/perl

=pod
    
=head1 NAME
	
 grep.pl - grep a given column with a Perl regular expression.

=head1 SYNOPSIS
    
  grep.pl [options] filename

  Options:
    -help            brief help message
    -man             full documentation

    -p               regular expression
    -col             column number to which the regex is applied.
	-v               invert match.

=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
    
    
    Prints the manual page and exits.
    
=back
    
=head1 Example
    
    cat yourfile.txt | grep.pl -col=1 -p='' 
    
=cut


use strict;
use Getopt::Long;
use Pod::Usage;


main();


sub analyze_args {
    my %opts = (v=>0);

    my $result = GetOptions(\%opts, "help!", "man!",
		"p=s", "col=i", "v!" ) or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}


sub main {
	my %opts = analyze_args();
	my $pattern = $opts{p};

	if (defined($opts{v}) && defined($opts{col})) {
		column_invert_match($pattern, $opts{col});
	}
	elsif (defined($opts{v}) && !defined($opts{col})) {
		invert_match($pattern);
	}
	elsif (!defined($opts{v}) && defined($opts{col})) {
		column_match($pattern, $opts{col});
	}
	elsif (!defined($opts{v}) && !defined($opts{col})) {
		match($pattern);
	}
}



sub column_invert_match {
	my $pattern = shift @_;
	my $col     = shift @_;
	
	while (<STDIN>) {
		chomp;
		my @c = tab_split($_);
		if ($c[$col] !~ /$pattern/) {
			print $_, "\n";
		}
	}  
}



sub invert_match {
	my $pattern = shift @_;
	
	while (<STDIN>) {
		chomp;
		if ($_ !~ /$pattern/) {
			print $_, "\n";
		}
	}  
}


sub column_match {
	my $pattern = shift @_;
	my $col     = shift @_;
	
	while (<STDIN>) {
		chomp;
		my @c = tab_split($_);
		if ($c[$col] =~ /$pattern/) {
			print $_;
		}
	}  
}



sub match {
	my $pattern = shift @_;
	
	while (<STDIN>) {
		chomp;
		if (/$pattern/) {
			print $_;
		}
	}  
}




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


__END__

