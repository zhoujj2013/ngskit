#!/bin/sh

if [ $# -lt 1 ];then
	echo ""
	echo "  Get stat."
	echo "  Author: zhoujj2013@gmail.com";
	echo "  usage: sh $0 XX.bam prefix";
	echo ""
	exit;
fi


#wget ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_27/gencode.v27.annotation.gtf.gz
#
#gunzip gencode.v27.annotation.gtf.gz
#
#less -S gencode.v27.annotation.gtf | grep -v "^#" | awk '$3 ~ /gene/' | perl get_information.pl - > gencode.v27.annotation.index
#
#less -S gencode.v27.annotation.gtf | grep -v "^#" | awk '$3 ~ /gene/' | /usr/bin/perl get_cor_information.pl - > gencode.v27.annotation.bed
#
#bedtools sort -i gencode.v27.annotation.bed > gencode.v27.annotation.sorted.bed
#

prefix=$2

Bin=$(dirname $0)

# uniq reads
#sh $Bin/get_uniq.sh $1 $prefix

# bam to bed
#bedtools bamtobed -i $prefix.bam > reads.bed
bedtools bamtobed -i $1 > reads.bed

# global
bedtools intersect -a reads.bed -b $Bin/gencode.v27.annotation.sorted.bed -wo > overlaping.details.txt

bedtools intersect -a reads.bed -b $Bin/gencode.v27.annotation.sorted.bed -v > nonoverlaping.details.txt

bedtools intersect -a reads.bed -b $Bin/gencode.v27.annotation.sorted.bed -u > overlaping.short.txt 

wc -l overlaping.short.txt nonoverlaping.details.txt > 1.result

# overlaping part 
bedtools intersect -a overlaping.short.txt -b $Bin/gencode.v27.annotation.exon.sorted.bed -wo -f 0.9 > overlaping.short.vs.exon.details.bed

bedtools intersect -a overlaping.short.txt -b $Bin/gencode.v27.annotation.exon.sorted.bed -v -f 0.9 > overlaping.short.vs.intron.details.bed

bedtools intersect -a overlaping.short.txt -b $Bin/gencode.v27.annotation.exon.sorted.bed -u -f 0.9 > overlaping.short.vs.exon.short.bed

wc -l overlaping.short.vs.intron.details.bed overlaping.short.vs.exon.short.bed > 2.result

/usr/bin/perl $Bin/get_count.pl ./overlaping.short.vs.exon.details.bed $Bin/rank.lst > 3.result

/x400ifs-accel/zhoujj/software/homer/bin/makeTagDirectory ./intron ./overlaping.short.vs.intron.details.bed -format bed
/x400ifs-accel/zhoujj/software/homer/bin/annotatePeaks.pl ./overlaping.short.vs.intron.details.bed hg38 > ./overlaping.short.vs.intron.details.anno 2>./overlaping.short.vs.intron.details.log

# nonoverlaping part
# wget http://bioinfo.au.tsinghua.edu.cn/dbsuper/20170915_HeLa.bed
# wget http://bioinfo.au.tsinghua.edu.cn/dbsuper/HeLa.bed

echo -ne "SEs\t" > 4.result && bedtools intersect -a nonoverlaping.details.txt -b $Bin/HeLa.bed -u | wc -l >> 4.result
echo -ne "Enhancer Const.\t" > 5.result && bedtools intersect -a nonoverlaping.details.txt -b $Bin/20170915_HeLa.bed -u | wc -l >> 5.result
/x400ifs-accel/zhoujj/software/homer/bin/makeTagDirectory ./intergenic ./nonoverlaping.details.txt -format bed
/x400ifs-accel/zhoujj/software/homer/bin/annotatePeaks.pl nonoverlaping.details.txt hg38 > nonoverlaping.details.anno 2>nonoverlaping.details.anno.log


