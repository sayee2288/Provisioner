#!/usr/bin/perl -w -I ../Pmodules/
#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This application will accept inputs with specific
#		parameters and perform operations based on it
#-----------------------------------------------------------------
use strict;
use Getopt::Long;
use File::Find;
use File::Path;
use core;

my %Arg=();
print "Creating a new core object \n";
my $object=new core(\%Arg);
