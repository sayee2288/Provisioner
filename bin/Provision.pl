#!/usr/bin/perl -w -I ../Pmodules/
#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This application will accept inputs with specific
#		parameters and perform operations based on it
# Usage:	Provision.pl --Json=path to config file
#-----------------------------------------------------------------
use strict;
use warnings;
use core;
#use Data::Dumper;
use JSON;

usage () if @ARGV<1;

print "Welcome to provisioner, your json file will be parsed and validated now \n";
sleep 2;

# This is a reference to the hash that holds the parsed json file
my $Arg;
die "Error" unless json_parse();

# Initializing the Configuration management object
my $cm=new core($Arg);

$cm->validate($Arg);

sub json_parse
{
	local $/;
        open( my $fh, '<', $ARGV[0] );
        $Arg=decode_json( <$fh> );
	print "Parsing complete, validation in progress \n";
	sleep 2;
}

sub usage
{
print STDERR <<USAGE_END;
Usage:
Provision.pl --Json="Path to Json file"
Options:
	--Json  : Absolute Path to the Json file.

Author: Sayee Iere
USAGE_END
exit 1;
}
