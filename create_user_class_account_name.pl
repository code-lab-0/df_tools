#!/usr/bin/perl

=pod
    
=head1 NAME
	
 create_user_class_account_name.pl - get account name from a table and add user class prefix.

=head1 SYNOPSIS
    
  create_user_class_account_name.pl [options]

  Options:
    -help            brief help message
    -man             full documentation

=head1 OPTIONS
    
=over 8
    
=item B<-help>
    
    Print a brief help message and exits.
    
=item B<-man>
        
    Prints the manual page and exits.

=item B<-kc>
        
=back
    
=head1 DESCRIPTION
    
=head2 get account name from a table and add user class prefix.

  cat table.txt | create_user_class_account_name.pl > result.out

=cut

use strict;
use warnings;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use utf8;
use Encode;
use Encode::Argv ('utf8');
use open ':encoding(utf8)';
use open ':std';

main();

#
#-------------------------------------------------
#

sub main {
    &class_account__value();
}

sub class_account__value {
    my $value = shift @_;
    while (<>) {
        chomp;
        my @cols = split(/\t/, $_, -1);
        if ($cols[7]) {
            print("ippan_$cols[7]\t$cols[0]\t一般ユーザー\t$cols[7]\t$cols[8]\t$cols[9]\n");
        }
        if ($cols[10]) {
            print("daikibo_$cols[10]\t$cols[0]\t大規模ユーザー\t$cols[10]\t$cols[11]\t$cols[12]\n");
        }
        if ($cols[13]) {
            print("migap_$cols[13]\t$cols[0]\tMIGAPユーザー\t$cols[13]\t$cols[14]\t$cols[15]\n");
        }
        if ($cols[16]) {
            print("pipeline_$cols[16]\t$cols[0]\tPIPELINEユーザー\t$cols[16]\t$cols[17]\t$cols[18]\n");
        }
        if ($cols[19]) {
            print("gyoumu_$cols[19]\t$cols[0]\t業務ユーザー\t$cols[19]\t$cols[20]\t$cols[21]\n");
        }
        if ($cols[22]) {
            print("se_$cols[22]\t$cols[0]\tSEユーザー\t$cols[22]\t$cols[23]\t$cols[24]\n");
        }
    }
}
__END__

