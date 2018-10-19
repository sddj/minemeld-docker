0. You need leveldb to install the plyvel Python package and rrdtool for the rrdtool Python package
```
brew install leveldb rrdtool
```
1. Make wrappers for the PyCharm debugger:
```
cd $w/minemeld-core
mkdir -p minemeld/cli
echo 2.7.15 >.python-version
(echo .python-version; echo minemeld/cli) >> .gitignore
(
  echo "from minemeld.run.launcher import main"
  echo "from minemeld.flask.main import app"
  echo
  echo
  echo "if __name__ == '__main__':"
  echo "    patch_all()"
  echo "    main()"
) >minemeld/cli/engine.py
(
  echo "from gevent.monkey import patch_all"
  echo "from minemeld.flask.main import app"
  echo
  echo
  echo "if __name__ == '__main__':"
  echo "    patch_all()"
  echo "    app.run()"
) >minemeld/cli/web.py
```

2. Configure a launcher for the engine as follows:

Script path: $w/minemeld-core/minemeld/cli/engine.py
Parameters: .
Environment variables:
  - PYTHONUNBUFFERED=1
  - OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
  - MINEMELD_PROTOTYPE_PATH=../../minemeld-node-prototypes/prototypes
  - MINEMELD_NODES_PATH=../../minemeld-core/nodes.json
Working directory: $w/minemeld-docker/minemeld.d

3. Configure a launcher for the web as follows:

Script path: $w/minemeld-core/minemeld/cli/web.py
Parameters: .
Environment variables:
  - PYTHONUNBUFFERED=1
  - MM_CONFIG=.
  - MINEMELD_LOCAL_PATH=../shared.d
  - API_CONFIG_LOCK=./api/api-config.lock
  - REDIS_URL=redis://127.0.0.1:10001/0
Working directory: $w/minemeld-docker/minemeld.d

3. Setup password files:

```
htpasswd -bc $w/minemeld-docker/minemeld.d/api/wsgi.htpasswd admin minemeld
htpasswd -bc $w/minemeld-docker/minemeld.d/api/feeds.htpasswd admin minemeld
```

4. Build and start the docker-based services:

```
docker-compose build
docker-compose up collectd rabbitmq redis
g```

5. Debug
