#! /bin/bash
#Star Pi
# please do this first:
#sudo apt-get update
#sudo apt-get dist-upgrade
#sudo rpi-update
#git clone https://github.com/ChrisDick/StarPi
#chmod u+x install.sh
#./install

#remove?
#sudo sed -i -e "\$adeb http://http.debian.net/debian wheezy-backports main" /etc/apt/sources.list
#sudo apt-get install debian-archive-keyring 
#sudo apt-get -t wheezy-backports install scons

sudo apt-get -y install libncurses5-dev python-dev pps-tools git-core scons

cd ./Software

#Gps deamon
wget http://git.savannah.gnu.org/cgit/gpsd.git/snapshot/gpsd-master.tar.gz
tar -zxvf  gpsd-master.tar.gz

rm gpsd-master.tar.gz

cp -r gpsd-master/* ./Src/GPSD 
rm -r gpsd-master

cd ./Src/GPSD 
sudo scons && sudo scons check && sudo scons udev-install

cd ./../..
mkdir Obj
mkdir Out
make
#copy executables to somewhere in the PATH
sudo cp ./Out/StarPi /usr/local/bin/StarPi
sudo cp  websocketd /usr/local/bin/websocketd
sudo cp WMM.COF /usr/local/bin/WMM.COF
cd ..
#ToDo check /var/www exists before RPiCAMInterface is installed.
sudo cp -r ./Website/* /var/www/StarPi

#rpicam interface
git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git
cp RPi_Cam_config.txt ./RPi_Cam_Web_Interface/config.txt
sudo mkdir /var/www/StarPi
sudo mkdir /var/www/RPiCam/
cd RPi_Cam_Web_Interface
chmod u+x install.sh
sudo ./install.sh q
#line above will ask for reboot, so this may should never happen.
#add default web interface page
#sudo cp -r ./www/* /var/www/RPiCam