#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;
use Time::Piece;

my $dir1 		= "./directory1"; 						#will be replaced with LocalStorage
my $dir2 		= "./directory2"; 						#will be replaced with Archive
my $date 		= localtime->strftime('%m%d%Y'); 		#string format time , current month day year with no spaces
my $archive 	= "$dir2/$date"; 						#folder in dir2 named with current month day year
my $killDcc     = 'taskkill /IM "Calculator.exe" /F'; 	#will be replaced with DCC
my $startDcc   	= 'start calc.exe'; 				    #will be replaced with DCC
            
#**************************************************
#	Sub Routine to kill DCC, open and read dir1,  *
#	make archive and transfer dir1 files to it    *
#**************************************************

sub transferFiles {									
													
	system($killDcc);								
													
	opendir (DIR, $dir1);							
													
	while(my $file = readdir DIR){
		mkdir 	$archive;
		move	("$dir1/$file" , "$archive/$file");
		}
			
	closedir DIR;
	
	system($startDcc)	
}

#*******************************************************************
#	Decision making: if dir2 already exist execute transferFiles,  *
#	Else make dir2 folder first	before transferFiles			   *
#*******************************************************************

if(-e $dir2){
	transferFiles();
	}else{
	mkdir $dir2;
	transferFiles();
}








