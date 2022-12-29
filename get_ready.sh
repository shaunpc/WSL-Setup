# Core Operating System Updates
sudo get update
sudo get upgrade -y
sudo apt dist-upgrade
do-release-upgrade

# Simple login script changes
sudo apt install screenfetch
echo "" >> .profile
echo "# Display pretty machine and login details" >> .profile
echo "echo" >> .profile
echo "screenfetch" >> .profile
echo "echo" >> .profile

# Setup GIT
sudo apt install git
git config --global user.name "Shaun Cotter"
git config --global user.email "shauncotter00@gmail.com"
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager-core.exe"
git clone https://github.com/shaunpc/WSL-Setup.git

# Setup JAVA (a bit clunky to be able to get/set JAVA_HOME)
sudo apt install default-jdk
java -version
JAVA_LOC="$(update-alternatives --config java | cut -d':' -f2 -s | cut -c2- | cut -d' ' -f1 )"
echo "JAVA_HOME=$JAVA_LOC" >> .profile
JAVA_HOME=$JAVA_LOC
