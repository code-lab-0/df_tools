#!/usr/bin/perl

=pod
    
=head1 NAME
	
 parse_uge_usage_table.pl - スパコンチームの全体会議資料からダウンロードした月別利用状況のHTMLファイルをパースして、アカウントごとに、使用したキューのジョブ投入回数・CPU使用時間・メモリ使用量を出力する。

=head1 SYNOPSIS
    
  parse_uge_usage_table.pl [options]

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

  cat table.html | parse_uge_usage_table.pl > result.out

=cut

use strict;
use warnings;
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
    my $parsed_data;
    my @lines = &get_lines();
    foreach my $line (@lines) {
        my @cols = ();
        while ($line =~ s/<t[dh] .*?>(.*?)<\/t[dh]>//i) {
            push @cols, $1;
        }
        my @queues = &get_queue_list($cols[4]);
        my @submit_counts = &get_submit_count_list($cols[5]);
        my @cpu_times = &get_cpu_time_list($cols[6]);
        my @memory_usages = &get_memory_usage_list($cols[7]);
        for (my $i = 0; $i <= $#queues; $i++) {
            $parsed_data->{$cols[1]}->{'queue'}->{$queues[$i]}->{'submit_count'} = $submit_counts[$i];
            $parsed_data->{$cols[1]}->{'queue'}->{$queues[$i]}->{'cpu_time'} = $cpu_times[$i];
            $parsed_data->{$cols[1]}->{'queue'}->{$queues[$i]}->{'memory_usage'} = $memory_usages[$i];
        }
        $parsed_data->{$cols[1]}->{'disk_usage'} = $cols[8];
    }
    foreach my $user (sort keys %$parsed_data) {
        foreach my $queue (sort keys %{$parsed_data->{$user}->{'queue'}}) {
            print "$user\t";
            print "$queue\t";
            print "$parsed_data->{$user}->{'queue'}->{$queue}->{'submit_count'}\t";
            print "$parsed_data->{$user}->{'queue'}->{$queue}->{'cpu_time'}\t";
            print "$parsed_data->{$user}->{'queue'}->{$queue}->{'memory_usage'}\n";
        }
    }
}

sub get_lines {
    my $data;
    while (<>) {
        s/\r//;
        s/\n//;
        $data .= $_;
    }
    my @lines;
    $data =~ s/.*<table.*?>(.*)<\/table>.*/$1/;
    while ($data =~ s/<tr>(.*?)<\/tr>//i) {
        push @lines, $1;
    }
    return @lines;
}

sub get_queue_list {
    my $str = shift @_;
    my @queues = split /<br>/, $str;
    pop @queues;
    if ($#queues > -1) {
        push @queues, 'total';
    }
    return @queues;
}

sub get_submit_count_list {
    my $str = shift @_;
    my @submit_counts = split(/<br>/, $str, -1);
#    pop @submit_counts;
    pop @submit_counts;
    my @submit_counts2 = map { $_ =~ s/,//g; $_ } @submit_counts;
    my @submit_counts3 = map { $_ =~ s/^.*?(\d+).*?$/$1/; $_ } @submit_counts2;
    return @submit_counts3;
}

sub get_cpu_time_list {
    my $str = shift @_;
    my @cpu_times = split(/<br>/, $str, -1);
#    pop @cpu_times;
    pop @cpu_times;
    my @cpu_times2 = map { $_ =~ s/,//g; $_ } @cpu_times;
    my @cpu_times3 = map { $_ =~ s/^.*?(\d+).*?$/$1/; $_ } @cpu_times2;
    return @cpu_times3;
}

sub get_memory_usage_list {
    my $str = shift @_;
    my @memory_usages = split(/<br>/, $str, -1);
#    pop @memory_usages;
    pop @memory_usages;
    my @memory_usages2 = map { $_ =~ s/,//g; $_ } @memory_usages;
    my @memory_usages3 = map { $_ =~ s/^.*?(\d+).*?$/$1/; $_ } @memory_usages2;
    return @memory_usages3;
}

__END__

