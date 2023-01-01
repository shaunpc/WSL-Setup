# set some color variables for highlighting progress
source ~/WSL-Setup/colors.sh
echo -e '\n' $BBlue $(date +"%D") $Green 'STARTING Setup Script\n' $Color_Off

# Core Operating System Updates
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 1 >> Performing Ubuntu updates\n' $Color_Off
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt dist-upgrade
do-release-upgrade

# Simple login script changes
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 2 >> Updating .profile \n' $Color_Off
sudo apt install screenfetch -y
echo "" >> .profile
echo "# Display pretty machine and login details" >> .profile
echo "echo" >> .profile
echo "screenfetch" >> .profile
echo "echo" >> .profile

# Setup GIT
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 3 >> Setting up GIT\n'  $Color_Off
sudo apt install git -y
git config --global user.name "Shaun Cotter"
git config --global user.email "shauncotter00@gmail.com"
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git -y
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
# ALREADY DONE : git clone https://github.com/shaunpc/WSL-Setup.git

# Setup JAVA (a bit clunky to be able to get/set JAVA_HOME)
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 4 >> Setting up JAVA\n' $Color_Off
sudo apt install default-jdk -y
java -version
JAVA_LOC="$(update-alternatives --config java | cut -d':' -f2 -s | cut -c2- | cut -d' ' -f1 )"
echo "JAVA_HOME=\"$JAVA_LOC\"" | sudo tee -a /etc/environment
source /etc/environment

# Setup KAFKA (requires JAVA setup first)
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 5 >> Setting up KAFKA\n' $Color_Off
sudo useradd -r -d /opt/kafka -s /usr/sbin/nologin kafka
sudo curl -fsSLo kafka.tgz https://dlcdn.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar -xzf kafka.tgz
sudo mv kafka_2.13-3.3.1 /opt/kafka
sudo chown -R kafka:kafka /opt/kafka
echo -e $Red ' >> INFO << Leaving /opt/kafka/config/server.properties with default log file directory' $Color_Off '(log.dirs=/tmp/kafka-logs)'

# Setup PYTHON 
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 6 >> Setting up PYTHON\n' $Color_Off
sudo apt install python3 -y
sudo apt install python3-pip -y

# Setup MongoDB
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 7 >> Setting up MONGO DB\n' $Color_Off
echo -e $Red ' ###    NOT DONE YET    ### \n' $Color_Off


# Setup SQLite3
echo -e '\n' $BBlue $(date +"%T") $Green 'Step 8 >> Setting up SQLite\n' $Color_Off
sudo apt install sqlite3 -y
sqlite3 --version


# And we're done!
echo -e '\n' $BBlue $(date +"%T") $Green 'COMPLETED Setup Script\n'  $Color_Off
