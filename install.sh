#/usr/bin/bash
# Bootstrap script to handle dependencies on first time setup
# Verifying that this master server is ubuntu
echo "Installing Provisioner";

if sudo apt-get -v &>/dev/null; then
        echo "Definitely ubuntu, Proceeding with installation";
else
        echo "Not an ubuntu system, this tool will only work on Ubuntu distributions";
        exit 1;
fi

if sudo apt-get update &>/dev/null; then
        echo "Updating apt-get repositories";
else
        echo "Failed to updated apt-get repositories, still proceeding with install ...";
fi

if perl -v &>/dev/null; then
        echo "Perl already exists";
else
        echo "Installing perl"
        if sudo apt-get perl -y &>/dev/null; then
                echo "Perl installed";
        else
                echo "Failed to install Perl";
                exit 1;
        fi
fi

if sudo apt-get install liblog-log4perl-perl -y &>/dev/null; then
	echo "Installed log4perl";
else
	echo "Log4perl installation failed, application installation exiting";
	exit 1;
fi

if sudo apt-get install libjson-pp-perl -y &>/dev/null; then
        echo "Installed libjson for perl";
else
        echo "libjson installation failed, application installation exiting";
        exit 1;
fi

if mkdir -p log templates; then
	echo "Created log and templates directory";
else
	echo "Failed to create log and templates directory, please create them manually next to the bin directory, for this tool to function";
fi
