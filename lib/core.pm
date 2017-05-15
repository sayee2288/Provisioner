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
our $RSYNC  ="/usr/bin/rsync";
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
		}
	}	
        # Operations identified and validated, now sorting them by priority
        my @custom_order = qw/ remove install configure service /;
        my %order = map +($custom_order[$_] => $_), 0 .. $#custom_order;
        @{$Arg->{operations}}=sort {$order{$a} <=> $order{$b}} @{$Arg->{operations}};
}

sub install
{
        my $self = shift;
        my $Arg = shift;
	my $Server = shift;
	my $ID = shift;
        my @RemoteCommands = ();
	print $Server, $ID;

        # Looping through the install array to identify modules
        foreach my $module (keys %{$Arg})
        {
		if ($Arg->{$module} eq "auto")
		{
                        $log->info("Package to be installed: $module, no version specified, choosing automatically");
                        push(@RemoteCommands, "sudo apt-get install $module -y");
		} else {
                	$log->info("Package to be installed: $module version: $Arg->{$module}");
                	push(@RemoteCommands, "sudo apt-get install $module=$Arg->{$module} -y");
		}
        }

	$log->logdie("Failed to complete remote installation server") if SSHExec($ID,$Server,\@RemoteCommands);
}


sub remove
{
        my $self = shift;
        my $Arg = shift;
        my $Server = shift;
        my $ID = shift;
        my @RemoteCommands = ();

        # Looping through the remove array to identify package
        foreach my $package (keys %{$Arg})
        {
                if ($Arg->{$package} eq "auto")
                {
                        $log->info("Package to be removed: $package, no version specified, choosing automatically");
                        push(@RemoteCommands, "sudo apt-get remove $package -y");
                } else {
                        $log->info("Package to be removed: $package version: $Arg->{$package}");
                        push(@RemoteCommands, "sudo apt-get remove $package=$Arg->{$package} -y");
                }
        }

        $log->logdie("Failed to complete remote uninstallation on server") if SSHExec($ID,$Server,\@RemoteCommands);
}

sub configure
{
        my $self = shift;
        my $Arg = shift;
        my $Server = shift;
        my $ID = shift;
        my @RemoteCommands = ();

        foreach my $module (keys %{$Arg})
        {
        	$log->info("Chosen module: $module, no version specified, choosing automatically");
       		my $Command="$RSYNC -avz ../templates/$module $ID\@$Server:".$Arg->{$module};
		print Dumper($Command);
		my @Messages=`$Command 2>&1`;
		$log->info("@Messages");
        }
}

sub service
{
        my $self = shift;
        my $Arg = shift;
        my $Server = shift;
        my $ID = shift;
        my @RemoteCommands = ();

        # Looping through the remove array to identify modules
        foreach my $module (keys %{$Arg})
        {
        	$log->info("Perform $Arg->{$module} of service $module");
       		push(@RemoteCommands, "sudo service $module $Arg->{$module}");
        }

        $log->logdie("Failed to perform specified operation on services") if SSHExec($ID,$Server,\@RemoteCommands);
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
	return $?;
}

1;
