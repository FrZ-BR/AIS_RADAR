#!/bin/bash

clear

echo "============================================="
echo "Auto Radar download, build and update script"
echo "               Version 1.15"
echo "============================================="

ip1=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

#U need to run this as Root, MAH BOI
if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as ROOT. Use command:" 
   echo "sudo $PWD/$(basename -- $0)" 
   exit 0
fi

#check if u have java, son
echo "Checking JAVA....."
if [[ $(javac -version | grep -c javac) > 0 ]]
then
	echo "Java found"
else
	echo "No java found"
	echo "Installing...."
	sudo add-apt-repository --yes ppa:webupd8team/java > /dev/null
	sudo apt-get --yes update > /dev/null
	sudo apt --yes --force-yes install oracle-java9-installer > /dev/null
	sudo apt --yes --force-yes install oracle-java9-set-default > /dev/null
fi

#check if u have maven, son
echo "Checking Maven....."
if [[ $(mvn -version | grep -c "Apache Maven") > 0 ]]
then
	echo "Maven found"
else
	echo "No Maven found"
	echo "Installing...."
	sudo apt-get --yes update > /dev/null
	sudo apt-get --yes --force-yes install maven > /dev/null
fi

#check if u have git, son
echo "Checking Git....."
if [[ $(git --version | grep -c version) > 0 ]]
then
	echo "Git found"
else
	echo "No Git found"
	echo "Installing...."
	sudo apt-get --yes update > /dev/null
	sudo apt-get --yes --force-yes install git > /dev/null
fi

echo "===================================="
echo "Downloading new radar..."
echo "===================================="

#do you have mah previous build?
if [[ -d $HOME/Radar/Radar_temp ]]
then
	cd $HOME/Radar/Radar_temp
	if [[ $(git pull | grep -c Already) > 0 ]]
	then
		echo "Radar is already latest version.. Exiting"
		exit
	fi
	git pull 
else
	git clone git://github.com/Jerry1211/RadarProject $HOME/Radar/Radar_temp > /dev/null
	cd $HOME/Radar
	echo "===================================="
	echo "    Enter you game PC ip please"
	echo "       example - 192.168.1.2"
	echo "===================================="
	read ip2
	while [[ $(echo "$ip2" | grep -c '^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$') = 0 ]]
	do 
		echo "WRONG INPUT"
		echo "TYPE IP ADRESS, LIKE 192.168.1.2!!!!"
		read ip2
	done
	echo "sudo java -jar Rad.jar $ip1 PortFilter $ip2" > run.sh
	chmod +x run.sh
fi

cd $HOME/Radar/Radar_temp
echo "===================================="
echo "Building JAR..."
echo "===================================="
mvn install > /dev/null
mv $HOME/Radar/Radar_temp/target/VMRadar-1.2.1-jar-with* $HOME/Radar/Rad.jar


echo "==========================================="
echo "                   Done!"
echo "Run $HOME/Radar/run.sh now and play PUBG ;)"
echo "==========================================="


