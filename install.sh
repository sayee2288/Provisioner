#/bin/bash
echo "Commencing installation";

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
	echo "Failed to create log and templates directory, please create them manually for application to function";
fi
