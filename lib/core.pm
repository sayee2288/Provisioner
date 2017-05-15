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
use Data::Dumper;
use Log::Log4perl;
Log::Log4perl->init("../lib/logger.conf"); 	# Module fails to detect local files, hence the relative path

our $SCP   = `which scp`;
our $SSH   ="/usr/bin/ssh -q -o BatchMode=yes";
our $RSYNC  = `which rsync`;
our $log = Log::Log4perl->get_logger("");

sub new
{
	my $class = shift;
	my $self = shift;
	bless $self, $class;
	return $self;
}

sub validate
{
	my $self = shift;
	my $Arg = shift;
	#my $log = Log::Log4perl->get_logger("");

	foreach my $key (keys %{$Arg})
	{
		if ($key eq "install"){
			push(@{$Arg->{operations}}, "install");
		} elsif ($key eq "remove"){
			push(@{$Arg->{operations}}, "remove");
		} elsif ($key eq "configure"){
			push(@{$Arg->{operations}}, "configure");
		} elsif ($key eq "service"){
                        push(@{$Arg->{operations}}, "service");
		} else { next; }
	}	
}

sub sort_by_priority
{
	my $self = shift;
        my $Arg = shift;
	
        # Operations identified and validated, now sorting them by priority
        my @custom_order = qw/ remove install configure service /;
        my %order = map +($custom_order[$_] => $_), 0 .. $#custom_order;
	@{$Arg->{operations}}=sort {$order{$a} <=> $order{$b}} @{$Arg->{operations}};
}

sub install
{
        my $self = shift;
        my $Arg = shift;
        my @RemoteCommands = ();

        # Looping through the install array to identify modules
        foreach my $module (keys %{$Arg})
        {
		if ($Arg->{$module} eq "auto")
		{
                        $log->info("Chosen module: $module, no version specified, choosing automatically");
                        push(@RemoteCommands, "sudo apt-get install $module -y");
		} else {
                	$log->info("Chosen module: $module version: $Arg->{$module}");
                	push(@RemoteCommands, "sudo apt-get install $module=$Arg->{$module}");
		}
        }

	$log->logdie("Failed to complete ssh execution on remote server") if SSHExec("ubuntu","ec2-34-210-183-211.us-west-2.compute.amazonaws.com",\@RemoteCommands);
}


sub remove
{
 	print "In remove operation \n";
}

sub configure
{
	print "In configure operation \n";
}

sub service
{

}

sub SSHExec
{
	my $ServiceID  = shift;
	my $Server     = shift;
	my $Batch      = shift; # Array  reference (list of commands)
	my @Messages=();
	my $ExitStatus = shift; # Scalar reference (valid for single command)

	my $RemoteCmd = sprintf("\"%s 2>&1\"",join(" 2>&1;", @{$Batch}));
	my $Command = "$SSH $ServiceID\@$Server $RemoteCmd";
	#print $Command;
	@Messages= `$Command 2>&1`;
	chomp @Messages;
	$log->info("@Messages");

	# Experimental : Exit status is valid if batch size is one (ie. one command)
	#if( ( @{$Batch} eq 1 ) && defined $ExitStatus ){
	#	$$ExitStatus = int($?/256);
	#} else {
	#	$$ExitStatus = undef;
	#}
	return;
}

1;
