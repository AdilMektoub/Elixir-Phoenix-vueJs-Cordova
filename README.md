# Time Manager Epitech MSC-Pro

## Guide d'installation

* Cloner le repository et aller dans le dossier TimeManager2
    ```
    git clone git@github.com:AdilMektoub/Elixir-Phoenix-vueJs-Cordova.git

    cd TimeManagerOk
    ```

* Installer et compiler les dépendances du serveur Phoenix:
    ```
    cd server

    mix do deps.get, deps.compile

    cd ..
    ```

* Installer les outils nécessaires pour le devOps
    ```
    ./install.sh
    ```

* Une fois fait, appuyez sur **ctrl+c** pour quitter le processus

* Pour compiler tous les projets et tester l'application:
    ```
    docker-compose build --no-cache

    docker-compose up
    ```

* Vous pouvez naviguer à présent avec les URL suivants:
    * [Phoenix (server)](http://localhost:4000 "Serveur Phoenix")
    * [VueJS (client)](http://localhost:8080 "Client VueJS")
    * [Grafana](http://localhost:82 "Grafana")
    * [Prometheus](http://localhost:9090 "Prometheus")
