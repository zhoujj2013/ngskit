#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<0;

sub usage {
        my $usage = << "USAGE";

        For statistics result.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 

USAGE
print "$usage";
exit(1);
};

open IN,"1.result" || die $!;
my $genic = <IN>;
my $intergenic = <IN>;
my $total = <IN>;
close IN;

my @genic = split /\s+/,$genic;
my @intergenic = split /\s+/,$intergenic;
my @total = split /\s+/,$total;

print "# Global statistics\n";
print "Total\t$total[1]\n";
print "genic\t$genic[1]\n";
print "intergenic\t$intergenic[1]\n";


open IN,"2.result" || die $!;
my $intron = <IN>;
my $exon = <IN>;
close IN;

my @intron = split /\s+/,$intron;
my @exon = split /\s+/,$exon;

print "\n# genic part global\n";
print "intron\t$intron[1]\n";
print "exon\t$exon[1]\n";


print "\n\n\n# genic part\n";
print "intron\t$intron[1]\n";

open IN,"3.result" || die $!;
while(<IN>){
	print $_;
}
close IN;


print "\n\n\n# intergenic part\n";
my $flag = 0;
my %h;
my $total_intergenic = 0;
open IN,"nonoverlaping.details.anno.log" || die $!;
while(<IN>){	
	chomp;
	if(/^\s+To capture/){
		$flag = 1;
		next;
	}
	if(/^\s+Counting Tags/){
		last;
	}
	next if(/^\s+Annotat/);
	if($flag == 1){
		my @t= split /\s+/; 
		if($t[1] eq "LINE"){
			$h{"LINE"} = $t[2];
			$total_intergenic = $total_intergenic + $t[2];
		}

		if($t[1] eq "SINE"){
                        $h{"SINE"} = $t[2];
			$total_intergenic = $total_intergenic + $t[2];
                }
		if($t[1] eq "Intergenic"){
                        $h{"Intergenic"} = $t[2];
                        $total_intergenic = $total_intergenic + $t[2];
                }
		if($t[1] eq "Promoter"){
                        $h{"Promoter"} = $t[2];
                        $total_intergenic = $total_intergenic + $t[2];
                }
		if($t[1] eq "LTR"){
                        $h{"LTR"} = $t[2];
                        $total_intergenic = $total_intergenic + $t[2];
                }
		#print "$t[1]\t$t[2]\n";
	}
}
close IN;

$h{"others"} = $intergenic[1] - $total_intergenic;

foreach my $k (sort keys %h){
	print "$k\t$h{$k}\n";
}

print "\n\n# enhancer part\n";
print `cat 4.result`;
print `cat 5.result`;


print "\n\n\n# rRNA in intergenic region\n";
$flag = 0;
open IN,"nonoverlaping.details.anno.log" || die $!;
while(<IN>){	
	chomp;
	if(/^\s+To capture/){
		$flag = 1;
		next;
	}
	if(/^\s+Counting Tags/){
		last;
	}
	next if(/^\s+Annotat/);
	if($flag == 1){
		my @t= split /\s+/; 
		if($t[1] eq "rRNA"){
			$h{"rRNA"} = $t[2];
			print "$t[1]\t$t[2]\n";
			#$total_intergenic = $total_intergenic + $t[2];
		}
		#print "$t[1]\t$t[2]\n";
	}
}
close IN;


print "\n\n\n# rRNA in intron region\n";
$flag = 0;
open IN,"./overlaping.short.vs.intron.details.log" || die $!;
while(<IN>){	
	chomp;
	if(/^\s+To capture/){
		$flag = 1;
		next;
	}
	if(/^\s+Counting Tags/){
		last;
	}
	next if(/^\s+Annotat/);
	if($flag == 1){
		my @t= split /\s+/; 
		if($t[1] eq "rRNA"){
			$h{"rRNA"} = $t[2];
			print "$t[1]\t$t[2]\n";
			#$total_intergenic = $total_intergenic + $t[2];
		}
		#print "$t[1]\t$t[2]\n";
	}
}
close IN;

