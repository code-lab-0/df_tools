#!/usr/bin/perl

use strict;
# use Getopt::Long;
use Pod::Usage;

main();


#
#-------------------------------------------------
#


sub main {
	my $a = join(" ", @ARGV);
	my @s = split /\\t/, $a;
	print join("\t", @s), "\n";
}


__END__

=head1 NAME

 echo.pl -- print strings.

=head1 SYNOPSYS

 echo '見出し1\theader 2'

=cut
