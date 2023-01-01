## Starting from WIN11 Powershell
ZAP any exist distribution AND the associated ROOT file structure, and reinstall fresh
```
PS$ wsl --unregister Ubuntu
PS$ wsl --install Ubuntu
```
## And if you ever wanted to close WSL all down...
```
PS$ wsl --shutdown
```
---

## From new UBUNTU terminal
As part of install enter a suitable username and password, then when presented with prompt, clone this WSL-Setup repo, and kick off the magic... 
```
$ git clone https://github.com/shaunpc/WSL-Setup.git
$ source WSL-Setup/get_ready.sh
```
This script attempts to automate as much of the following as possible!

<span style="color:red">HEALTH WARNING : Probably assumes too much of the 'happy-path' in execution!</span>
<br/><br/>

# Setting up a development environment on a fresh WSL2 
Basically going to follow these Steps
1. Ensure Operating System components are fully up-to-date (including major version upgrade checks)
2. Add some login niceities into .profile
3. Install and configure GIT (including GITHUB credentials)
4. Install latest JAVA OpenJDK version
5. Install latest Kafka version
6. Install latest Python3/PIP3 versions
7. Install latest MongoDB version
8. Install latest SQLite version


And generally following these guidelines:
- https://learn.microsoft.com/en-us/windows/wsl/setup/environment
- https://www.howtoforge.com/tutorial/ubuntu-apache-kafka-installation/

---
<br/><br/>
<span style="color:cyan">ADDITIONAL NOTES</span>
---
<br/><br/>

---
## NOTE: VSCODE : Install VScode
```
code .
```
|Key|Description|
|---|-----------|
|CTRL-K V | View Markdown side-by-side|

<br/><br/>

---
## NOTE: MONGO : How to set upSet up MongoDB

- https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-mongodb
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
