#!/bin/bash

# clone le projet
apt-get install git
git clone https://github.com/Namachi06/TimeManager2.git

# on change le build dans le package.json
#cd client/
#grep -Ei --color "build" package.json
#if [ grep -Ei --color "build" package.json = "build": "rimraf ../mobile/www/* && vue-cli-service build && cd .. && cd mobile && cordova build android && cordova run android",]
#then
#        echo "C'est vrai"
#fi
# le s c'est substitution,le \ c'est pour pouvoir mettre un caractère spécial dans l'expression, le / c'est le délimiteur à l'intérieur de l'expression, le ' c'est le délimiteur de l'expression
#sed -i 's/\(build=\).*/\1"rimraf ../mobile/www/* && vue-cli-service build && cd .. && cd mobile && cordova build android && cordova run android"/' package.json
#cd ..

./install.sh

docker-compose build
docker-compose up

cd mobile
cordova build android
cordova run android