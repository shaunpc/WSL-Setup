# Setting up a development environment on a fresh WSL2 

Basically going to follow these guidelines

https://learn.microsoft.com/en-us/windows/wsl/setup/environment

##
## Update all components:
```
apt-get update 
apt-get upgrade
apt-get autoremove
```

## Update to latest Distribution
```
apt-get dist-upgrade
do-release-upgrade
```

## Add some niceities in own login script
```
cd ~
apt install screenfetch

nano .bash-profile
    # My specific login file

    # Call local user profile file if it exsits...
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
    # Display pretty machine and login details
    echo
    screenfetch
    echo
```


## Install VScode
```
code .
```
|Key|Description|
|---|-----------|
|CTRL-K V | View Markdown side-by-side|


## Set up GIT
```
apt-get git
git config --global user.name "Shaun Cotter"
git config --global user.email "shauncotter00@gmail.com"
add-apt-repository ppa:git-core/ppa
apt-get install git
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
```


## Set up GITHUB
```
All done from VS-Code - innitialised repo, commmitted change and pushed to github new repo
```

## Set up JAVA
```
sudo apt install default-jdk
java -version
# Add JAVA_HOME variable with location of java
update-alternatives --config java  
sudo nano /etc/environment
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/bin/java"
source /etc/environment
echo $JAVA_HOME
```

## Set up Kafka (need JAVA first)
https://www.howtoforge.com/tutorial/ubuntu-apache-kafka-installation/

```
sudo useradd -r -d /opt/kafka -s /usr/sbin/nologin kafka
sudo curl -fsSLo kafka.tgz https://dlcdn.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
tar -xzf kafka.tgz
sudo mv kafka_2.13-3.3.1 /opt/kafka
sudo chown -R kafka:kafka /opt/kafka
sudo -u kafka mkdir -p /opt/kafka/logs
sudo -u kafka nano /opt/kafka/config/server.properties
    # logs configuration for Apache Kafka
    log.dirs=/opt/kafka/logs

```

## Set up Python
```
[sudo apt install python3] -- Already Installed
sudo apt install python3-pip

```

## Set up MongoDB
https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-mongodb
```
cd ~
sudo apt update
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
mongod --version
```
If it complains about the open files limit
```
# ulimit -a
# ulimit n=40000
```

Create default database location at top level
```
mkdir -p /data/db
mongod    # starts the server visible in the terminal
[CTRL_X]
```
Enable as service for easy start/stop
```
sudo nano /etc/init.d/mongod 
PASTE : https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d
chmod +x /etc/init.d/mongod
chown mongodb:mongodb /var/run/mongod.pid
```
Start backend server, test it out, then shut it down
```
sudo service mongod start
more /var/log/mongodb/mongod.log 

mongosh
test> show dbs
test> exit

sudo service mongod stop
```

## Set up SQLITE3
https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-sqlite
```
cd ~
sudo apt update
sudo apt install sqlite3
sqlite3 --version
```
My databases
```
mkdir ~/data/sqlite3
sqlite ~/data/sqlite3 pingtrend.db
.quit 
```

## Close it all down
```
Powershell
    $ wsl --shutdown
```
