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
TODO
```

## Set up JAVA
```
TODO
```

## Set up Kafka
```
TODO
```

## Set up MongoDB
```
TODO
```
## Close it all down
```
Powershell
    $ wsl --shutdown
```
