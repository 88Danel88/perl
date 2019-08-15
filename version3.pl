#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;
use Time::Piece;

my $dir1 			= 	"./directory1"; 						#will be replaced with LocalStorage
my $dir2 			= 	"./directory2"; 						#will be replaced with Archive
my $date 			= 	localtime->strftime('%Y%m%d'); 			#string format time , current month day year with no spaces
my $archive 		= 	"$dir2/$date"; 							#folder in dir2 named with current month day year
my $killDcc     	= 	'taskkill /IM "Calculator.exe" /F'; 	#will be replaced with DCC
my $startDcc   		= 	'start calc.exe'; 				    	#will be replaced with DCC

#*******************************************************************
#	Decision making: if dir2 already exist execute transferFiles,  *
#	Else make dir2 folder first	before transferFiles			   *
#*******************************************************************

mkdir $dir2 	 if(!-e $dir2);
mkdir $archive   if(!-e $archive);
&transferFiles() if( -e $dir2);
exit 0;


#**************************************************
#	Sub Routine to kill DCC, open and read dir1,  *
#	make archive and transfer dir1 files to it    *
#**************************************************

sub transferFiles {									
													
	
	&logAll("DCC Terminated") if(system($killDcc)==0);
	
	
	&logAll("Moving files from $dir1 to $archive");												
	opendir (DIR, $dir1);							
													
	while(my $file = readdir DIR){
		
		move("$dir1/$file" , "$archive/$file");
		
		}
		
	if(closedir DIR == 1){
		&logAll("Finished transfering files!");
	};
	
	
	&logAll("DCC Started!") if(system($startDcc)==0);	
		
}

###############
# WRITE TO LOG
###############
sub logAll
{
  my $msg           = shift;
  my $abort         = shift||"N";        #<-- (OPTIONAL) Y=TERMINATE SCRIPT; N=NO(DEFAULT)
  my $log_dir		= "./LOGS";
  my $log_file      = "$log_dir/" . &get_date_time(1) . ".log";
  my ($date, $time) = &get_date_time(3);
  
    
  ### CREATE LOG DIR ###
  if (! -e $log_dir)
  {
    mkdir "$log_dir";
  }
  
  ### WRITE TO LOG ### 
  open LOG, ">$log_file"  or print "Can't write to $log_file. $!\n" if !-e $log_file;
  open LOG, ">>$log_file" or print "Can't write to $log_file. $!\n" if  -e $log_file;
  print LOG "[${date} ${time}] ${msg}\n";
  close(LOG);
  
  ### SHOW MSG TO CONSOLE ###
  print "$msg\n";
  
  ### TERMINATE SCRIPT ###
  if ($abort eq "Y")
  {    
    ### KILL ONLY ON 3RD CRITICAL ERROR OCCURRENCE ###     
    my $error_counter++; 
    return if $error_counter < 3;        
    exit 1;
  }
  
}

#######################
# GET DATE AND/OR TIME
#######################
sub get_date_time
{
  my $req    = shift;  
  my $mytime = shift||time;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($mytime);
  my  $milli = sprintf "%03d", ($mytime-int($mytime))*1000;
      $sec   = &two_digits($sec);
      $min   = &two_digits($min);
      $hour  = &two_digits($hour);
      $mday  = &two_digits($mday);    
      $mon   = &two_digits(++$mon);    
      $year += 1900;    
  
  return("${year}${mon}${mday}")             						if $req==1;  ### RETURN DATE ONLY
  return("${hour}${min}${sec}")             						if $req==2;  ### RETURN TIME ONLY    
  return("${year}${mon}${mday}", "${hour}:${min}:${sec}")         	if $req==3;  ### RETURN DATE & TIME  
  return("${mon}\/${mday}\/${year}", "${hour}\:${min}\:${sec}")     if $req==5;  ### RETURN DATE & TIME
  return($year,$mon,$mday,$hour,$min,$sec)               			if $req==6;  ### RETURN DATE & TIME
}

########################
# ENSURE 2-DIGIT FORMAT
########################
sub two_digits
{
  my $d = shift;
     $d = "0".int($d)  if $d  < 10;
  return($d);
}