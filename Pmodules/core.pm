#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This is the core module of the application
#		and contains all the methods used by Provisioner
#----------------------------------------------------------------- 
package core;
use Exporter;
@ISA       = qw(Exporter);
@EXPORT    = qw();
@EXPORT_OK = qw();

use strict;
use File::Find;
use File::Path;
use File::Copy;
use File::Basename;
use Log::Log4perl;
Log::Log4perl->init("../Conf/logger.conf");

my $SCP   = `which scp`;
my $SSH   = `which ssh`." -q -o BatchMode=yes";
my $RSYNC  = `which rsync`;
my @ERROR = ();

sub new
{
	my $class = shift;
	my $self = shift;
	bless $self, $class;
	return $self;
}

sub error
{
	my $self = shift;
	return \@ERROR;
}

sub test
{
	my $self = shift;
	my $log = Log::Log4perl->get_logger("");
	$log->error("Test error message");
	$log->debug("Test debug message");
}
1;
