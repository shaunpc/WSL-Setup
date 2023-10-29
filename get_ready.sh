# set some color variables for highlighting progress
time_start=`date +%s`
source ~/WSL-Setup/colors.sh
echo -e '\n' $BBlue $(date +"%D") $Green "STARTING Setup Script\n" $Color_Off
STEP=0

# Core Operating System Updates
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Performing Ubuntu updates\n" $Color_Off
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt dist-upgrade
do-release-upgrade

# Simple login script changes
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Updating .profile \n" $Color_Off
sudo apt install screenfetch -y
echo "" >> .profile
echo "# Display pretty machine and login details" >> .profile
echo "echo" >> .profile
echo "screenfetch" >> .profile
echo "echo" >> .profile
echo "source ./WSL-Setup/colors.sh" >> .profile

# Ensure VS Code installs itself 
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Checking VS Code install \n" $Color_Off
code -v
whereis code

# Setup GIT
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up GIT\n"  $Color_Off
sudo apt install git -y
git config --global user.name "Shaun Cotter"
git config --global user.email "shauncotter00@gmail.com"
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt install git -y
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"

# Setup JAVA (a bit clunky to be able to get/set JAVA_HOME)
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up JAVA\n" $Color_Off
sudo apt install default-jdk -y
java -version
JAVA_LOC="$(update-alternatives --config java | cut -d':' -f2 -s | cut -c2- | cut -d' ' -f1 | cut -d"/" -f1-5)"
echo "export JAVA_HOME=\"$JAVA_LOC\"" | sudo tee -a /etc/profile
export JAVA_HOME="$JAVA_LOC"

# Setup PYTHON 
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up PYTHON\n" $Color_Off
sudo apt install python3 -y
sudo apt install python3-pip -y
pip install requests
pip install beautifulsoup4

# Setup KAFKA (requires JAVA setup first)
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up KAFKA\n" $Color_Off
# sudo useradd -r -d /opt/kafka -s /usr/sbin/nologin kafka
echo "Creating KAFKA user account, please set password"
sudo useradd -r -d /opt/kafka kafka
sudo passwd kafka
# Call python routine to determine latest KAFKA version download file and store in file as variables
python3 WSL-Setup/get_latest_kafka.py
source kafka-version.sh
rm -vf kafka-version.sh
echo -e $Blue '\tInstalling from: ' $KAFKA_VSN_FULL $Color_Off
sudo curl -fsSLo kafka.tgz $KAFKA_VSN_FULL
tar -xzf kafka.tgz
sudo mv $KAFKA_VSN_SHORT /opt/kafka
sudo chown -R kafka:kafka /opt/kafka
echo "export KAFKA_HOME=\"/opt/kafka\"" | sudo tee -a /etc/profile
export KAFKA_HOME="/opt/kafka"
# Change the default KAFKA log directory
sudo -u kafka mkdir -p /opt/kafka/logs
sudo -u kafka cp -v $KAFKA_HOME/config/server.properties $KAFKA_HOME/config/server.properties_orig
awk '{sub("log.dirs=/tmp/kafka-logs","log.dirs=/opt/kafka/logs")}1' $KAFKA_HOME/config/server.properties_orig > TEMP_KAFKA_server.properties_new
sudo cp -v TEMP_KAFKA_server.properties_new $KAFKA_HOME/config/server.properties
rm -v TEMP_KAFKA_server.properties_new 
echo "export KAFKA_LOGS=\"/opt/kafka/logs\"" | sudo tee -a /etc/profile
export KAFKA_LOGS="/opt/kafka/logs"
rm -vf kafka.tgz

# Setup MongoDB
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up MONGO DB\n" $Color_Off
wget -qO - https://pgp.mongodb.com/server-6.0.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-org-6.0.gpg
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo wget -O /etc/init.d/mongod https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d
sudo chmod +x /etc/init.d/mongod
# TODO - STILL NOT QUITE FINISHED!
sudo touch /var/run/mongod.pid
sudo chown mongodb:mongodb /var/run/mongod.pid
sudo mkdir -v -p /data/db
sudo chown mongodb:mongodb /data/db
mkdir -v -p ~/data/mongodb
mongod --version

# Setup SQLite3
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up SQLite\n" $Color_Off
sudo apt install sqlite3 -y
mkdir -v -p ~/data/sqlite3
sqlite3 --version

# Clone the PingTrends Repo
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Clone PingTrends repo\n" $Color_Off
git clone https://github.com/shaunpc/WSL-PingTrends.git


# Let's summarite the VERSIONS
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Summarising Installed Versions\n"  $Color_Off
echo -e $Cyan '\tUBUNTU\t: ' $Green $(source /etc/lsb-release && echo $DISTRIB_DESCRIPTION | cut -d' ' -f2) $Color_Off
echo -e $Cyan '\tVS-Code\t: ' $Green $(code -v | head -n 1) $Color_Off
echo -e $Cyan '\tGIT\t: ' $Green $(git --version | cut -d' ' -f3) $Color_Off
echo -e $Cyan '\tJAVA\t: ' $Green $(javac -version | cut -d' ' -f2) $Color_Off
echo -e $Cyan '\tKAFKA\t: ' $Green $(/opt/kafka/bin/kafka-topics.sh --version | cut -d' ' -f1) $Color_Off
echo -e $Cyan '\tPYTHON\t: ' $Green $(python3 --version | cut -d' ' -f2) $Color_Off
echo -e $Cyan '\tMONGODB\t: ' $Green $(mongod --version | head -n 1 | cut -d' ' -f3) $Color_Off
echo -e $Cyan '\tSQLITE\t: ' $Green $(sqlite3 --version | cut -d' ' -f1) $Color_Off

# And we're done!
time_end=`date +%s`
echo -e '\n' $BBlue $(date +"%T") $Green "COMPLETED Setup Script (`expr $time_end - $time_start` seconds to execute)\n"  $Color_Off
