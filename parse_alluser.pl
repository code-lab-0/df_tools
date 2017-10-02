#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use utf8;
use open ":utf8";
use open ":std";

&main;

sub main {
    my %opts = analyze_args();
    if ($opts{personal}) {
        &get_personal_data;
    } elsif ($opts{account}) {
        &get_account_data;
    } elsif ($opts{group}) {
        &get_group_data;
    } else {
        print "usage: parse_alluser.pl --personal|--acount|--group < input > output\n";
    }
}

sub analyze_args {
    my %opts = ( personal => 0, account => 0 );
    Getopt::Long::GetOptions(\%opts, qw( personal account group )) or exit 1;
    return %opts;
}

sub get_group_data {
    my($personal_data, $account_data, $group_data) = &read_input;
    OUTER: foreach my $group_id (sort keys %$group_data) {
        foreach my $start_day (sort { $b <=> $a } keys %{$group_data->{$group_id}}) {
            foreach my $data_ref (@{$group_data->{$group_id}->{$start_day}}) {
                my $str = join("\t", @$data_ref);
                print "$group_id\t$str\n";
                next OUTER;
            }
        }
    }
}

sub get_personal_data {
    my($personal_data, $account_data, $group_data) = &read_input;
#    foreach my $mail (sort keys %$personal_data) {
#        foreach my $class (sort keys %{$personal_data->{$mail}}) {
#            foreach my $start_day (sort { $a <=> $b } keys %{$personal_data->{$mail}->{$class}}) {
#                foreach my $data_ref (@{$personal_data->{$mail}->{$class}->{$start_day}}) {
#                    my $str = join("\t", @$data_ref);
#                    print "$mail\t$str\t$class\n";
#                }
#            }
#        }
#    }

    OUTER: foreach my $mail (keys %$personal_data) {
        if (defined($personal_data->{$mail}->{'一般'})) {
            my $count = 0;
            foreach my $start_day (sort { $a <=> $b } keys %{$personal_data->{$mail}->{'一般'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'一般'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    if ($count > 0) {
                        print "[D] $mail\t$str\t一般\n";
                        ++$count;
                    } else {
                        print "$mail\t$str\t一般\n";
                        ++$count;
#                    next OUTER;
                    }
                }
            }
            next OUTER;
        } elsif (defined($personal_data->{$mail}->{'大規模'})) {
            my $count = 0;
            foreach my $start_day (sort { $a <=> $b } keys %{$personal_data->{$mail}->{'大規模'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'大規模'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    if ($count > 0) {
                        print "[D] $mail\t$str\t大規模\n";
                        ++$count;
                    } else {
                        print "$mail\t$str\t大規模\n";
                        ++$count;
#                    next OUTER;
                    }
                }
            }
            next OUTER;
        } elsif (defined($personal_data->{$mail}->{'業務'})) {
            foreach my $start_day (sort { $b <=> $a } keys %{$personal_data->{$mail}->{'業務'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'業務'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    print "$mail\t$str\t業務\n";
                    next OUTER;
                }
            }
        } elsif (defined($personal_data->{$mail}->{'SE'})) {
            foreach my $start_day (sort { $b <=> $a } keys %{$personal_data->{$mail}->{'SE'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'SE'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    print "$mail\t$str\tSE\n";
                    next OUTER;
                }
            }
        } elsif (defined($personal_data->{$mail}->{'MiGAP'})) {
            foreach my $start_day (sort { $b <=> $a } keys %{$personal_data->{$mail}->{'MiGAP'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'MiGAP'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    print "$mail\t$str\tMiGAP\n";
                    next OUTER;
                }
            }
        } elsif (defined($personal_data->{$mail}->{'PIPELINE'})) {
            foreach my $start_day (sort { $b <=> $a } keys %{$personal_data->{$mail}->{'PIPELINE'}}) {
                foreach my $data_ref (@{$personal_data->{$mail}->{'PIPELINE'}->{$start_day}}) {
                    my $str = join("\t", @$data_ref);
                    print "$mail\t$str\tPIPELINE\n";
                    next OUTER;
                }
            }
        }
    }
}

sub get_account_data {
    my($personal_data, $account_data, $group_data) = &read_input;
    my %prefix = (
        '一般' => 'ippan',
        '大規模' => 'daikibo',
        '業務' => 'gyoumu',
        'SE' => 'se',
        'MiGAP' => 'migap',
        'PIPELINE' => 'pipeline'
    );
    foreach my $mail (keys %{$account_data}) {
        foreach my $data_ref (@{$account_data->{$mail}}) {
            my $prefix = $prefix{$data_ref->[0]};
            print "${prefix}_$data_ref->[1]\t$mail\t$data_ref->[0]\t$data_ref->[1]\t$data_ref->[2]\t$data_ref->[3]\t$data_ref->[4]\t$data_ref->[5]\n";
        }
    }
}

sub read_input {
    my $personal_data;
    my $account_data;
    my $group_data;
    my $count = 0;
    while (<>) {
        chomp;
        my @cells = split(/\t/, $_, -1);
        my @tmp1 = ($cells[1], $cells[2], $cells[3], $cells[4], $cells[5], $cells[6]);
        my @tmp2 = ($cells[7], $cells[8], $cells[9], $cells[10], $cells[11], $cells[12]);
        my @tmp3 = ($cells[13], $cells[14]);
        if ($cells[0]) {
            push @{$personal_data->{$cells[0]}->{$cells[7]}->{$cells[9]}}, \@tmp1;
            push @{$account_data->{$cells[0]}}, \@tmp2;
        } else {
            push @{$personal_data->{"NO_MAIL_${count}"}->{$cells[7]}->{$cells[9]}}, \@tmp1;
            push @{$account_data->{"NO_MAIL_${count}"}}, \@tmp2;
            ++$count;
        }
        if ($cells[12]) {
            push @{$group_data->{$cells[12]}->{$cells[9]}}, \@tmp3;
        }
    }
    return($personal_data, $account_data, $group_data);
}

