#!/bin/bash

clear

echo "============================================="
echo "Auto Radar download, build and update script"
echo "               Version 1.20"
echo "============================================="

ip1=$(ip addr show | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

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
echo "What version of radar do you want?"
echo "===================================="
echo "1) Jerry1211"
echo "2) Rage verison of Jerry radar"
read sl1

case $sl1 in
 	1)
		rad_dir=$HOME/Radar/Radar_Jerry
		git_base=git://github.com/Jerry1211/RadarProject
 		;;
 	2)
		rad_dir=$HOME/Radar/Radar_Rage
		git_base=git://github.com/theRageNT/RageRadar
		;;
	*)
		echo "WRONG INPUT, EXITING...."
		;;
esac 

echo "===================================="
echo "Downloading new radar..."
echo "===================================="

#do you have mah previous build?
if [[ -d $rad_dir ]]
then
	cd $rad_dir
	if [[ $(git pull | grep -c Already) > 0 ]]
	then
		echo "Radar is already latest version. Exiting..."
		exit
	fi
	git pull 
else
	git clone $git_base $rad_dir > /dev/null
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

cd $rad_dir
echo "===================================="
echo "Building JAR..."
echo "===================================="
mvn install > /dev/null
mv $rad_dir/target/*with-dependencies.jar $HOME/Radar/Rad.jar


echo "==========================================="
echo "                   Done!"
echo "Run $HOME/Radar/run.sh now and play PUBG ;)"
echo "==========================================="


