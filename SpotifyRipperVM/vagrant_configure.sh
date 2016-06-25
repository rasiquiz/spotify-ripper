#!/bin/sh

# This file includes all operations to create a working instance of spotify-ripper

# Update apt-get
sudo apt-get update

# Add respository
sudo apt-add-repository multiverse

ENVS_TO_PUSH_TO_ENV_FILE="LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 PYTHONIOENCODING=utf-8"
for env in ${ENVS_TO_PUSH_TO_ENV_FILE}; do
    if grep -Fxq "$env" /etc/environment; then
        echo "env $env is set"
    else
        echo ${env} >> /etc/environment
    fi
done

# Install encoding
#sudo apt-get install language-pack-UTF-8
locale-gen en_GB.UTF-8
dpkg-reconfigure locales

#Install required packages
apt-get -y install \
        lame build-essential libffi-dev python-pip libffi-dev libssl-dev python-dev flac libav-tools faac \
        libfdk-aac-dev automake autoconf vorbis-tools opus-tools

# Install MP4/M4A (need to compile fdkaac from source)
wget https://github.com/nu774/fdkaac/archive/v0.6.2.tar.gz
tar xvf v0.6.2.tar.gz
cd fdkaac-0.6.2
autoreconf -i
./configure
make install

# Install libspotify
wget https://developer.spotify.com/download/libspotify/libspotify-12.1.51-Linux-x86_64-release.tar.gz
tar xvf libspotify-12.1.51-Linux-x86_64-release.tar.gz
cd libspotify-12.1.51-Linux-x86_64-release/
make install prefix=/usr/local

# Workaround for issue #214
/usr/bin/yes | pip uninstall spotify-ripper-morgaroth
pip install --upgrade pip
export CONFIGURE_OPTS="--enable-unicode=ucs4"
#pyenv install 3.5.1
#pyenv local 3.5.1
#pyenv global 3.5.1

# Install spotify-ripper
pip install spotify-ripper-morgaroth

# Create directories
f="/home/vagrant/.spotify-ripper"
if [ -d "$f" ]; then
	echo "$f exists."
else
	echo "$f doesn't exists, creating."
    mkdir ${f}
fi

f="/vagrant/Music/"
if [ -d "$f" ]; then
	echo "$f exists."
else
	echo "$f doesn't exists, creating."
    mkdir ${f}
fi


# Copy config-file
file="/vagrant/Settings/config.ini"
if [ -f "$file" ]; then
    link_target=/home/vagrant/.spotify-ripper/config.ini
	rm -f ${link_target}
	echo "$file found. Linking file to ~/.spotify-ripper"
	ln -s "$file" ${link_target}
else
	echo "$file not found."
fi

# Copy spotify-key
file2="/vagrant/Settings/spotify_appkey.key"
if [ -f "$file2" ]
then
    link_target=/home/vagrant/.spotify-ripper/spotify_appkey.key
	rm -f ${link_target}
	echo "$file2 found. Linking file to ~/.spotify-ripper"
	ln -s "$file2" /home/vagrant/.spotify-ripper/spotify_appkey.key
else
	echo "$file2 not found. You need a spotify developer key to transcode pcm stream."
	echo "Please copy your spotify_appkey.key to your shared host directory /vagrant/Settings/"
fi

# final feedback
echo "Voila - Run 'vagrant ssh' to access your virtual box"
echo "After that you should able to download songs"
echo "e.g. spotify-ripper spotify:track:4txn9qnwK3ILQqv5oq2mO3"
echo "Have Fun!"