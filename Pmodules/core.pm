#-----------------------------------------------------------------
# Author :	Sayee Iere
# Description:	This module takes all the parameters and handles
#		the configuration on the node
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

my $SCP   = "/usr/bin/scp";
my $SSH   = "/usr/bin/ssh -q -o BatchMode=yes";
my $RSYNC  = "/usr/bin/rsync";
my @ERROR = ();

sub new
{
	my $class=shift;
	my $self = shift;
	bless $self, $class;
	return $self;
}
1;
