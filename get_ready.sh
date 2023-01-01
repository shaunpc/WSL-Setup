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

# Ensure VS Code installs itself 
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Checking VS Code install \n" $Color_Off
code -v
whereis code
# This bit is a fudge - if left to without, the 'code' command is not recognised
# I *think* that symbolica links are the answer... but... 
alias code="/mnt/c/Users/shaun/AppData/Local/Programs/'Microsoft VS Code'/bin/code"
echo "echo" >> .profile
echo "# Setup alias for VS-Code executable on WSL" >> .profile
echo "export PATH=\$PATH:/mnt/c/Users/shaun/AppData/Local/'Microsoft VS Code'/bin/code" >> .profile
echo "echo" >> .profile

# Setup GIT
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up GIT\n"  $Color_Off
sudo apt install git -y
git config --global user.name "Shaun Cotter"
git config --global user.email "shauncotter00@gmail.com"
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt install git -y
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
# ASSUME ALREADY DONE : git clone https://github.com/shaunpc/WSL-Setup.git

# Setup JAVA (a bit clunky to be able to get/set JAVA_HOME)
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up JAVA\n" $Color_Off
sudo apt install default-jdk -y
java -version
JAVA_LOC="$(update-alternatives --config java | cut -d':' -f2 -s | cut -c2- | cut -d' ' -f1 )"
echo "JAVA_HOME=\"$JAVA_LOC\"" | sudo tee -a /etc/environment
source /etc/environment

# Setup KAFKA (requires JAVA setup first)
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up KAFKA\n" $Color_Off
# sudo useradd -r -d /opt/kafka -s /usr/sbin/nologin kafka
sudo useradd -r -d /opt/kafka kafka
sudo curl -fsSLo kafka.tgz https://dlcdn.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar -xzf kafka.tgz
sudo mv kafka_2.13-3.3.1 /opt/kafka
sudo chown -R kafka:kafka /opt/kafka
echo "KAFKA_HOME=\"/opt/kafka\"" | sudo tee -a /etc/environment
source /etc/environment
# Change the default KAFKA log directory
sudo -u kafka mkdir -p /opt/kafka/logs
sudo -u kafka cp -v $KAFKA_HOME/config/server.properties $KAFKA_HOME/config/server.properties_orig
awk '{sub("log.dirs=/tmp/kafka-logs","log.dirs=/opt/kafka/logs")}1' $KAFKA_HOME/config/server.properties_orig > TEMP_KAFKA_server.properties_new
sudo cp -v TEMP_KAFKA_server.properties_new $KAFKA_HOME/config/server.properties
rm -v TEMP_KAFKA_server.properties_new 
# echo -e $Red ' >> INFO << Leaving /opt/kafka/config/server.properties with default log file directory' $Color_Off '(log.dirs=/tmp/kafka-logs)'
rm -vf kafka.tgz

# Setup PYTHON 
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up PYTHON\n" $Color_Off
sudo apt install python3 -y
sudo apt install python3-pip -y

# Setup MongoDB
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up MONGO DB\n" $Color_Off
echo -e $Red ' ###    NOT DONE YET    ### \n' $Color_Off


# Setup SQLite3
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Setting up SQLite\n" $Color_Off
sudo apt install sqlite3 -y
mkdir -v -p ~/data/sqlite3
sqlite3 --version

# Let's summarite the VERSIONS
let STEP++
echo -e '\n' $BBlue $(date +"%T") $Green "Step $STEP >> Summarising Installed Versions"  $Color_Off
echo -e $Cyan '\tUBUNTU\t: ' $Green $(source /etc/lsb-release && echo $DISTRIB_DESCRIPTION | cut -d' ' -f2) $Color_off
echo -e $Cyan '\tVS-Code\t: ' $Green $(code -v | head -n 1) $Color_off
echo -e $Cyan '\tGIT\t: ' $Green $(git --version | cut -d' ' -f3) $Color_off
echo -e $Cyan '\tJAVA\t: ' $Green $(javac -version | cut -d' ' -f2) $Color_off
echo -e $Cyan '\tKAFKA\t: ' $Green $(/opt/kafka/bin/kafka-topics.sh --version | cut -d' ' -f1) $Color_off
echo -e $Cyan '\tPYTHON\t: ' $Green $(python3 --version | cut -d' ' -f2) $Color_off
echo -e $Cyan '\tMONGODB\t: ' $Green $() $Color_off
echo -e $Cyan '\tSQLITE\t: ' $Green $(sqlite3 --version | cut -d' ' -f1) $Color_off

# And we're done!
time_end=`date +%s`
echo -e '\n' $BBlue $(date +"%T") $Green "COMPLETED Setup Script (`expr $time_end - $time_start` seconds to execute)\n"  $Color_Off
