#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Pod::Usage;
use String::Strip;
use EzTable::ColumnHeader;

use open ":utf8";
use open ":std";

main();

#
#-------------------------------------------------
#

sub parseCommandLine {
    my %opts = (NA=>'\\N', glue=>"0,0");

    my $result = GetOptions(\%opts, "help!", "man!",
                            "tableDef=s",
                            "tableDef1=s",
                            "tableDef2=s",
                            "d=s",
                            "d1=s",
                            "d2=s",
			    "glue=s",
			    "file=s",
			    "NA=s") or pod2usage(2);


    if (defined($opts{d}) && !defined($opts{tableDef})) {
        $opts{tableDef} = $opts{d};
    }

    if (defined($opts{tableDef}) && !defined($opts{tableDef1})) {
        $opts{tableDef1} = $opts{tableDef};
    }

    if (defined($opts{d1}) && !defined($opts{tableDef1})) {
        $opts{tableDef1} = $opts{d1};
    }
    if (defined($opts{d2}) && !defined($opts{tableDef2})) {
        $opts{tableDef2} = $opts{d2};
    }


    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );




    return %opts;
}


sub main {
    my %opts = parseCommandLine();


    my  $header1 = EzTable::ColumnHeader->new;
    my  $header2 = EzTable::ColumnHeader->new;

    if (defined($opts{tableDef1})) {
        $header1->readTableDef($opts{tableDef1});
    }
    if (defined($opts{tableDef2})) {
        $header2->readTableDef($opts{tableDef2});
    }


    my ($glue1, $glue2) = split /[:,]/, $opts{glue};
    my ($g1, $g2);
    if ($glue1 !~ /^[0-9]+/) {
        $g1 = $header1->getColumnIndex($glue1);
    }
    else {
        $g1 = $glue1;
    }

    if (!defined($glue2)) {
        $g2 = $header2->getColumnIndex($glue1);
    }
    elsif ($glue2 !~ /^[0-9]+/) {
        $g2 = $header2->getColumnIndex($glue2);
    }
    else {
        $g2 = $glue2;
    }

    joining($opts{file}, $g1, $g2, $opts{NA});
}



sub joining {

    my $file = shift @_;
    my $glue1 = shift @_;
    my $glue2 = shift @_;
    my $NA    = shift @_;

    my %data = ();

    #--- Read data ---
    my $max = 0;
    open(DATA, $file) or die "* Error : Can not open $file : join.plx ";
    while (<DATA>) {
	chomp;
	my @col = tab_split($_);

	if ($max < $#col + 1) {
	    $max = $#col + 1;
	}

	my @a = ();
	for (my $i=0; $i<=$#col; $i++) {
	    if ($i != $glue2) {
		push @a, $col[$i];
	    }
	}
	push @{ $data{$col[$glue2]} }, [ @a ];
    }

    #------------
    while (<STDIN>) {
	chomp;
	my @col = tab_split($_);

	my @rows = ();
	if (defined($data{$col[$glue1]})) {
	    @rows = @{ $data{$col[$glue1]} };

	    foreach my $a ( @rows ) {
		print join("\t", @col, @{ $a }), "\n";
	    }
	    
	}
	else {
	    my @c = ();
	    push  @col, fixColNum(\@c, $max-1, $NA);
	    print join("\t", @col), "\n";
	}
	
    }
}



sub fixColNum {
    my @c = @{ $_[0] };
    my $n = $_[1];
    my $NA = $_[2];

    my @c2 = ();
    for (my $i=0; $i<$n; $i++) {
	if (defined($c[$i])) {
	    push @c2, $c[$i];
	}
	else {
	    push @c2, $NA;
	}
    }
    return @c2;
    
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
