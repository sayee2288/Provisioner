#!/usr/bin/perl -w -I ../lib
#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This application will accept inputs with specific
#		parameters and perform operations based on it
# Usage:	Provision.pl Json-File
#-----------------------------------------------------------------
use strict;
use warnings;
use core;
use Data::Dumper;
use JSON;

my $log = Log::Log4perl->get_logger("");
usage () if @ARGV<1;
$log->info("Your json file will be parsed and validated now");

# This is a reference to the associative array that holds the parsed json file
my $Arg;

# Parsing the Json file
json_parse();

# Initializing the Configuration management object
my $cm=new core($Arg);

$log->info("Parsing complete, validation in progress");
$cm->validate($Arg);
$log->info("No supported operations identified, please specify supported methods in json") && die if (!defined $Arg->{operations});
$log->info("No Servers defined in the json file, aborting execution") && die if (!defined $Arg->{servers});

foreach my $server(keys %{$Arg->{servers}})
{
	$log->info("Executing selected operations on $server using ID $Arg->{servers}{$server}:");
	foreach my $ops (@{$Arg->{operations}})
	{
	        $cm->$ops($Arg->{$ops},$server,$Arg->{servers}{$server}); # Passing the reference to the hash for the chosen operation
	}
}

sub json_parse
{
	local $/;
        $log->info("Unable to locate json file, ensure that the path is correct and readable") && die unless open( my $fh, '<', $ARGV[0] );
	$Arg=decode_json(<$fh>);
	close $fh;
}

sub usage
{
print STDERR <<USAGE_END;
Usage:
Provision.pl Json-File
Options:
	Json-File  : Absolute Path to the configuration json file.

Author: Sayee Iere
USAGE_END
exit 1;
}
