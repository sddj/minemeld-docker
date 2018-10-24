1. Setup minemeld-core

1.1. You need leveldb to install the plyvel Python package and rrdtool for the rrdtool Python package
```
brew install leveldb rrdtool nodeenv
```

1.2. Make wrappers for the PyCharm debugger:
```
cd $w/minemeld-docker
bin/setup-minemeld
```

1.3. Setup the "engine" debug target:
Script path: $w/minemeld-core/minemeld/cli/engine.py
Parameters: .
Environment variables:
  - PYTHONUNBUFFERED=1
  - OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
  - MINEMELD_PROTOTYPE_PATH=../../minemeld-node-prototypes/prototypes
  - MINEMELD_NODES_PATH=../../minemeld-core/nodes.json
Working directory: $w/minemeld-docker/minemeld.d

1.4. Setup the "web" debug target:
Script path: $w/minemeld-core/minemeld/cli/web.py
Parameters: .
Environment variables:
  - PYTHONUNBUFFERED=1
  - MM_CONFIG=.
  - MINEMELD_LOCAL_PATH=../shared.d
  - API_CONFIG_LOCK=./api/api-config.lock
  - REDIS_URL=redis://127.0.0.1:10001/0
Working directory: $w/minemeld-docker/minemeld.d

1.5. Setup the "traced" debug target:
Script path: $w/minemeld-core/minemeld/cli/traced.py
Parameters: traced.yml
Environment variables:
  - PYTHONUNBUFFERED=1
Working directory: $w/minemeld-docker/minemeld.d

1.6. Build and start the docker-based services:

```
docker-compose build
docker-compose up collectd rabbitmq redis
```

1.7. Debug the "engine" target

1.8. Debug the "web" target

1.9. Debug the "traced" target

2. Setup minemeld-webui

2.1. Configure WebStorm minemeld-webui project with ../nodeenv/minemeld-webui

On the "WebStorm>Preferences>Languages & Frameworks>Node.js and NPM" page, add a new local node interpreter

2.2. Open the Gulp tools window

Click "View>Tool windows>Gulp"

2.3. Setup the "serve" target

Right click on the "serve" Gulp target
Click "Edit 'serve' settings..."
Set arguments to: --url http://127.0.0.1:5000

2.4. Setup the "webui" target

Click "Run>Edit Configurations..."
Click "+>JavaScript Debug"
Set name to "webui"
Set URL to "http://localhost:3000"

2.5. Debug the "serve" target

2.6. Debug the "webui" target

2.7. Command line testing
```
cd $w/minemeld-webui
. ../pyenv/minemeld-webui/bin/activate
. ../nodeenv/minemeld-webui/bin/activate
PATH=$(npm bin):$PATH
gulp serve --url http://127.0.0.1:5000
```
