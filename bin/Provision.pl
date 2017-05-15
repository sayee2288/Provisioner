#!/usr/bin/perl -w -I ../lib
#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This application will accept inputs with specific
#		parameters and perform operations based on it
# Usage:	Provision.pl --Json=path to config file
#-----------------------------------------------------------------
use strict;
use warnings;
use core;
use Data::Dumper;
use JSON;

my $log = Log::Log4perl->get_logger("");
usage () if @ARGV<1;
$log->info("Your json file will be parsed and validated now");

# This is a reference to the hash that holds the parsed json file
my $Arg;
json_parse();

# Initializing the Configuration management object
my $cm=new core($Arg);

$log->info("Parsing complete, validation in progress");
$cm->validate($Arg);
$log->logdie("No supported operations identified, please specify supported methods in json") if (!defined $Arg->{operations});
$cm->sort_by_priority($Arg);

$log->info("Executing selected operations:");
foreach my $ops (@{$Arg->{operations}})
{
	$cm->$ops($Arg->{$ops}); # Passing the reference to the hash for the chosen operation
}


sub json_parse
{
	local $/;
        $log->logdie("Unable to locate json file, ensure that the path is correct and readable") unless open( my $fh, '<', $ARGV[0] );
	$Arg=decode_json(<$fh>);
	close $fh;
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
