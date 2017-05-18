#!/usr/bin/perl

=pod
    
=head1 NAME
	
 get.plx - get selected rows or columns from a table.

=head1 SYNOPSIS
    
  get.plx [options]

  Options:
    -help            brief help message
    -man             full documentation
    -tableDef        name of table definition file.

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

  cat table.txt | get.plx -cond="(@2 eq 'biological_process')"
  cat table.txt | get.plx -cond='[14:15]a(@==1)'

  # get lines from the top until the line which matches the pattern.
  cat text.txt  | get.plx -until="^the\s*pattern"
    
=cut

use strict;
use Getopt::Long;
use Pod::Usage;
use Set::IntSpan qw/grep_set map_set/;
use Set::Scalar;
#use String::Strip;
#use EzTable::ColumnHeader;

use open ":utf8";
use open ":std";

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


sub analyze_args {
    my %opts = ();

    my $result = GetOptions(\%opts, "help!", "man!",
			    "col=s",
			    "cond=s",
			    "row=s",
                            "c=s@",
                            "tableDef=s",
                            "d=s",
			    "row2=s") or pod2usage(2);
    
    pod2usage(1) if ($opts{help});
    pod2usage(-exitstatus=>0, -verbose=>2) if ( $opts{man} );

    if (defined($opts{d}) && !defined($opts{tableDef})) {
        $opts{tableDef} = $opts{d};
    }


    return %opts;
}


sub main {
    my %opts = analyze_args();
    
    if (defined($opts{row})) {
	get_row($opts{row});
    }
    elsif (defined($opts{row2})) {
	get_row2($opts{row2});
    }
    elsif (defined($opts{col})) {
	get_column($opts{col});
    }
    elsif (defined($opts{c})) {
	get_column2($opts{c}, $opts{tableDef});
    }
    elsif (defined($opts{cond})) {
	if ($opts{cond} =~ /^\(/) {
            condition($opts{cond}, $opts{tableDef});
	}
	else {
	    condition2($opts{cond});
	}
    }
}

#--------------------------------------


sub get_row {
  my $range = shift @_;

  my $set = new Set::IntSpan $range;
  my $lineNo = 0;

  while (<>) {
      if (member $set $lineNo) {
	  print $_;
      }
      $lineNo++;
  }
}


sub get_row2 {
  my $range = shift @_;

  my @row = ();
  while (<>) {
      chomp;
      push @row, $_;
  }

  my @out = ();
  my @idx = getIdx($range, $#row);
  for (my $i=0; $i<=$#idx; $i++) {
      push @out, $row[$idx[$i]];
  }
  print join("\n", @out), "\n";

}



# sub get_column2 {
#     my $colRef   = shift @_; # $colRef is a list of columnNames,
#                              # specified by -c options.
#     my $tableDef = shift @_; # Name of a table definition file.


#     my $header = EzTable::ColumnHeader->new();
#     $header->readTableDef($tableDef);

#     # Convert a list of columnName into a column delimited list of columnIndex.
#     my $range = $header->getColumnIndexListString($colRef);


#     get_column($range);
# }



sub get_column {
    my $range = shift @_;

    while (<>) {
	chomp;
	my @col = tab_split($_);
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




#-------------------------------------------------


sub condition {
    my $cond = shift @_;
    my $tableDef = shift @_;

    my @d = ();
    my %cx = ();

#    my $header = EzTable::ColumnHeader->new();
#    if (defined($tableDef)) {
#        $header->readTableDef($tableDef);
#    }



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

#        if (defined($tableDef)) {
#            for (my $i=0; $i<=$#c; $i++) {
#                my $name = $header->getColumnName($i);
#                $cx{$name} = $c[$i];
#            }
#        }

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
    my $set = new Set::IntSpan $range;
    my @ret = ();

    for (my $i=0; $i<=$#col; $i++) {
	if (member $set, $i) {
	    push @ret, $col[$i];
	}
    }
    return @ret;
}





__END__

