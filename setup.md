## Starting from WIN11 Powershell
ZAP any exist distribution AND the associated ROOT file structure, and reinstall fresh (will require new user/password created)
```shell
$ wsl --unregister Ubuntu
$ wsl --install Ubuntu
Enter new UNIX username: 
New password:
Retype new password:
```
And if you ever wanted to close WSL all down...
```shell
$ wsl --shutdown
```
---

## From new UBUNTU terminal
When presented with default Ubuntu prompt, clone this WSL-Setup repo, and kick off the magic... 
```shell
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
3. Install VS Code editor
4. Install and configure GIT (including GITHUB credentials)
5. Install latest JAVA OpenJDK version
6. Install latest Python3/PIP3 versions
7. Install latest Kafka version (determined on the fly!)
8. Install latest MongoDB version
9. Install latest SQLite version
10. Clones the PingTrends repo
11. Finally summarise the installed versions... 


And generally following these guidelines:
- https://learn.microsoft.com/en-us/windows/wsl/setup/environment
- https://www.howtoforge.com/tutorial/ubuntu-apache-kafka-installation/
- https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-mongodb
- https://www.mongodb.com/community/forums/t/how-to-install-mongodb-6-0-on-ubuntu-22-04/176976/9)


---
<br/><br/>
<span style="color:cyan">ADDITIONAL NOTES</span>
---
<br/><br/>

---
## NOTE: VSCODE : Shortcuts
|Key|Description|
|---|-----------|
|CTRL-K V | View Markdown side-by-side|

<br/><br/>

---
## NOTE: KAFKA - Testing KAFKA setup 
https://michaeljohnpena.com/blog/kafka-wsl2/

To enable testing interactively, first needed to enable the user for interactive mode, by removing the restricted shell set up (```-s /usr/sbin/nologin```) option in the original ```useradd``` setup script command
Secondly, set it up with an appropriate password with `$ sudo passwd kafka`

```shell
Create FOUR sessions, and run following commands in respective sessions: 
1. su kafka $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
2. su kafka $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
3. su kafka -c "$KAFKA_HOME/bin/kafka-console-producer.sh --topic sample-topic --broker-list localhost:9092"
4. su kafka -c "$KAFKA_HOME/bin/kafka-console-consumer.sh --topic sample-topic --from-beginning --bootstrap-server localhost:9092"
```

Then enter the text of the messages in the Producer session (#3) and watch them appear on the Consumer Session (#4) - cool!

Next, installed Docker for Windows, as per: https://docs.docker.com/desktop/install/windows-install/

Then start the two necesary containers (from Ubuntu; but these become visible in Docker for Windows as running  containers):
```shell
$ docker run -d -p 2181:2181 ubuntu/zookeeper:edge
$ docker run -d --name kafka-container -e TZ=UTC -p 9092:9092 -e ZOOKEEPER_HOST=host.docker.internal ubuntu/kafka:3.1-22.04_beta
```
Then, in one console, connect as Producer....
```
$ docker exec -it kafka-container /bin/bash
root@e3108937e0aa:/# kafka-console-producer.sh --topic sample-topic --broker-list localhost:9092
```
Then, in a second console, connect as Consumer....
```
$ docker exec -it kafka-container /bin/bash
kafka-console-consumer.sh --topic sample-topic --from-beginning --bootstrap-server localhost:9092
```
_Sidenote_: This link explains the latest Docker Kafka image: https://hub.docker.com/r/ubuntu/kafka

<br/>
<br/>

---
## NOTE: MONGO : How to set upSet up MongoDB

If it complains about the open files limit
```shell
# ulimit -a
# ulimit n=40000
```

Create default database location at top level - still not clear ...  so also created ~/data/mongodb   
```shell
$ mkdir -p /data/db
$ mongod    # starts the server visible in the terminal
[CTRL_X]
```
Enable as service for easy start/stop
```shell 
$ sudo nano /etc/init.d/mongod 
PASTE : https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d
$ chmod +x /etc/init.d/mongod
$ chown mongodb:mongodb /var/run/mongod.pid
```
Start backend server, test it out, then shut it down
```shell
$ sudo service mongod start
$ more /var/log/mongodb/mongod.log 

$ mongosh
test> show dbs
test> exit

$ sudo service mongod stop
```
