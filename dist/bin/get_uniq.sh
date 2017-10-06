#!/bin/sh

if [ $# -lt 2 ];then
	echo ""
	echo "	Author: zhoujj2013@gmail.com";
	echo "	usage: sh $0 xx.bam prefix";
	echo ""
	exit;
fi

prefix=$2

samtools view  $1 | grep  "AS:" | grep -v "XS:" > $prefix.sam
samtools view -H $1 > header.sam
cat header.sam $prefix.sam | samtools view -Sb - > $prefix.bam
samtools flagstat $prefix.bam > $prefix.flagstat
