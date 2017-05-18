#!/usr/bin/perl

use strict;
#use BerkeleyDB;
#use DB_File;
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
  my $result = GetOptions(\%opts, "help!", "man!", "homology!", "col=i", "big!") or pod2usage(2);
  pod2usage(1) if ($opts{help});
  pod2usage(-exitstatus=>0, -verbose=>2) if $opts{man};

  return %opts;
}


sub main {

  my %opts = analyze_opts();
  my %data = ();

  if (defined($opts{big})) {
    big_set_unique(\%opts);
  }
  elsif (defined($opts{col})) {
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



# sub big_set_unique {

#   my %opts = %{ $_[0] };
  
#   my $filename = "remove_redundancy_big.temp" . int(rand(1000));
#   my $db = new BerkeleyDB::Hash -Filename=>$filename, -Flags => DB_CREATE
#     or die "Cannot open file $filename: $! $BerkeleyDB::Error\n";
  
#   while (<STDIN>) {
#     chomp;
#     my $line = $_;
#     $db->db_put($line, 1);
#   }
  
#   my ($k, $v) = ("", "");
#   my $cursor = $db->db_cursor();
#   while ($cursor->c_get($k, $v, DB_NEXT) == 0) {
#     print "$k\n";
#   }
  
#   undef $cursor;
#   undef $db;
#   system("rm -f $filename");
# }

# sub big_set_unique {
#     my %opts = %{ $_[0] };
    
#     my (%db, $x);
    
#     # Enable duplicate records.
#     my $filename = "remove_redundancy_big.temp" . int(rand(1000));
#     $x = tie %db, 'DB_File', $filename, O_CREAT|O_RDWR, 0666, $DB_HASH
# 	or die "set_unique.plx : Can not open temporary file $filename";

    
#     while (<STDIN>) {
# 	chomp;
# 	my $line = $_;
# 	$db{$line}++;
#     }

#     my ($k, $v);
#     for (my $status = $x->seq($k, $v, R_FIRST) ;
# 	 $status == 0 ;
# 	 $status = $x->seq($k, $v, R_NEXT) ) {
#       print $k, "\n";
#     }

#     untie %db;
#     system("rm -f $filename");
# }


__END__

=head1 NAME

 remove_redundancy.plx - eliminate redundant row from a data file.

=head1 SYNOPSYS

 cat datafile | remove_redundancy.plx > result.data

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
