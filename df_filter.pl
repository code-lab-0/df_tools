#!/usr/bin/perl

=pod
    
=head1 NAME
	
 df_filter.pl - get rows matched to given conditions.

=head1 SYNOPSIS
    
  df_filter.pl [options]

  Options:
    -help            brief help message
    -man             full documentation
    -cond            an expression of filter conditions.

=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
    
    
    Prints the manual page and exits.
    
=back
    
=head1 DESCRIPTION
    
=head2 Get specified columns

  cat table.txt | df_filter.pl -cond='($c[2] eq "biological_process")'
  cat table.txt | df_filter.pl -cond='a[1-3,14,15](@==1)'
  cat table.txt | df_filter.pl -cond='{e>2}[1-3,14,15](@==1)'

    
=cut

use strict;
use Getopt::Long;
use Pod::Usage;

use open ":utf8";
use open ":std";

main();


#
#-------------------------------------------------
#


sub main {
    my %opts = analyze_args();
    
#	filter($opts{col});

	if ($opts{cond} =~ /^\(/) {
		condition($opts{cond});
	}
	else {
	    condition2($opts{cond});
	}
}




sub analyze_args {
    my %opts = ();

    my $result = GetOptions(\%opts, "help!", "man!", "cond=s") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    return %opts;
}

#--------------------------------------



sub tab_split {
    my $line = shift @_;

    $line =~ s/\t/\t /g;
    my @a = split(/\t/, $line);
    for (my $i=1; $i<=$#a; $i++) {
	$a[$i] = substr($a[$i], 1);
    }
    return @a;
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




#-------------------------------------------------


sub condition {
    my $cond = shift @_;

    my @d = ();
    my %cx = ();

    my $expr;
    my $com;
    
    if ($cond =~ /\((.+)\)/) {
		$expr = $1;
    }

    if (defined($expr)) {
		$com = "if ($expr) { return 1;} else { return undef; }";
    }

    while (my $line = <STDIN>) {
		chomp $line;
		my @c = tab_split($line);

		if (eval $com) {
			print $line, "\n";
		}
    }   
    
}




sub condition2 {
    my $cond = shift @_;

    if ($cond =~ /^a/) {
		condition_A($cond);
    }
    elsif ($cond =~ /^\{e/) {
		condition_E($cond);
    }
    elsif ($cond =~ /^e\[/) {
		$cond =~ s/^e/{e==1}/;
		condition_E($cond);
    }
    
}

sub condition_A {
    my $cond = shift @_;

    my $range;
    my $expr;
    my $com;
    
    if ($cond =~ /a\[(.+?)\]\((.+)\)/) {
		$range = $1;
		$expr  = $2;
    }

    if (defined($expr)) {
		$expr   =~ s/\@/\$data\[\$i\]/g;
		$com = "if ($expr) { return 1;} else { return undef; }";
    }
    

  OUTER: while (<STDIN>) {
	  chomp;
	  my $line = $_;
	  my @data = getData($line, $range);
	  if ($#data < 0) { next ; }

	  for (my $i=0; $i<=$#data; $i++) {
		  if (!eval $com) {
			  next OUTER;
		  }
	  }
	  print $line, "\n";
  }
}



sub condition_E {
    my $cond = shift @_;

    my $range;
    my $expr;
    my $com;
    my $op;
    my $times;
    
    if ($cond =~ /\{e(.+?)\}\[(.+?)\]\((.+)\)/) {
		$op    = $1;
		$range = $2;
		$expr  = $3;
    }

    if (defined($expr)) {
		$expr   =~ s/\@/\$data\[\$i\]/g;
		$com = "if ($expr) { return 1;} else { return undef; }";
    }
    

  OUTER: while (<STDIN>) {
	  chomp;
	  my $line = $_;
	  my @data = getData($line, $range);
	  if ($#data < 0) { next ; }

	  my $count = 0;
	  for (my $i=0; $i<=$#data; $i++) {
		  if (eval $com) {
			  $count++;
		  }
	  }

	  my $c = "if ($count $op) { return 1; } else { return undef }";
	  if (eval $c) {
		  print $line, "\n";
	  }    
  }
}



sub getData {
    my ($line, $range) = @_;
    
    my @col = tab_split($line);
    my $set = getIdx($range);
    my @ret = ();

    for (my $i=0; $i<=$#col; $i++) {
		if (member $set, $i) {
			push @ret, $col[$i];
		}
    }
    return @ret;
}





__END__

