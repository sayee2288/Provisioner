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

#-----------------------------------------------------------------
# Usage: Provision.pl
#	--configuration=path to config file
#	--
#
#-----------------------------------------------------------------

# This hash will contain all the arguments parsed from the json file
my %Arg=();

# Initializing the Configuration management object
my $cm=new core(\%Arg);

$cm->test();
#die "Error: ". join("\n",$cm->error())."\n";
