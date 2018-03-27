#!/bin/bash

clear

echo "============================================="
echo "Auto Radar download, build and update script"
echo "               Version 1.20"
echo "============================================="

#fuck dat shit man, dat home directory :D Fixing
HOME2=/home/$SUDO_USER

#detect IP of VM
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
	sudo add-apt-repository --yes ppa:webupd8team/java
	sudo apt-get --yes update > /dev/null
	sudo apt --yes --force-yes install oracle-java9-installer
	sudo apt --yes --force-yes install oracle-java9-set-default
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
echo "2) Verison of Jerry radar by Rage"
read sl1

case $sl1 in
 	1)
		name=Jerry
		rad_dir=$HOME2/Radar/Radar_Jerry
		git_base=git://github.com/Jerry1211/RadarProject
 		;;
 	2)
		name=Rage
		rad_dir=$HOME2/Radar/Radar_Rage
		git_base=git://github.com/theRageNT/RageRadar
		;;
	*)
		echo "WRONG INPUT, EXITING...."
		exit
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
	cd $HOME2/Radar
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
	echo "sudo java -jar Rad_$name.jar $ip1 PortFilter $ip2" > run_$name.sh
	chmod +x run_$name.sh
fi

cd $rad_dir
echo "===================================="
echo "Building JAR..."
echo "===================================="
mvn install
mv $rad_dir/target/*with-depend*.jar $HOME2/Radar/Rad_$name.jar


echo "==========================================="
echo "                   Done!"
echo "Run $HOME2/Radar/run.sh now and play PUBG ;)"
echo "==========================================="


