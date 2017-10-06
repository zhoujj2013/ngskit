#!/usr/bin/perl -w

use strict;

my $bed_f = shift;
my $lst_f = shift;

my %h;
open IN,"$lst_f" || die $!;
while(<IN>){
	chomp;
	my $class = $_;
	$h{$class} = 0;
}
close IN;


my %r;
open IN,"$lst_f" || die $!;
while(<IN>){
	chomp;
	my $class = $_;
	open OUT,">","wo.$class.details.bed" || die $!;
	open IN2,"$bed_f" || die $!;
	while(<IN2>){
		chomp;
		my @t = split /\t/;
		if($t[12] eq $class && !(exists $r{$t[3]})){
			$r{$t[3]} = 1;
			$h{$class}++;
		}elsif(!(exists $r{$t[3]})){
			print OUT "$_\n";
		}
	}
	close IN2;
	close OUT;
	$bed_f = "./wo.$class.details.bed";
}
close IN;

`rm wo.*.details.bed`;

open IN,"$lst_f" || die $!;
while(<IN>){
        chomp;
        my $class = $_;
        print "$class\t$h{$class}\n";
}
close IN;
