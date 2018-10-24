1. Setup minemeld-core

1.1. You need leveldb to install the plyvel Python package and rrdtool for the rrdtool Python package
```
brew install leveldb rrdtool
```

1.2. Make wrappers for the PyCharm debugger:
```
cd $w/minemeld-core
mkdir -p minemeld/cli
echo 2.7.15 >.python-version
(echo .python-version; echo minemeld/cli) >> .gitignore
(
  echo "from gevent.monkey import patch_all"
  echo ""
  echo "patch_all()"
  echo ""
  echo ""
  echo "def setup():"
  echo "    pass"
) >minemeld/cli/init.py
(
  echo "import sys"
  echo ""
  echo "from init import setup"
  echo ""
  echo "import json"
  echo "import os"
  echo ""
  echo "import pkg_resources"
  echo ""
  echo "from minemeld.run.launcher import main"
  echo ""
  echo ""
  echo "def _initialize_default_nodes_distribution(ws):"
  echo "    try:"
  echo "        with open(os.environ['MINEMELD_NODES_PATH'], 'r') as f:"
  echo "            node_definitions = json.load(f)"
  echo "        node_endpoints = ["
  echo "            '{} = {}'.format(xk, xv['class'])"
  echo "            for xk, xv in node_definitions.items()"
  echo "            if 'class' in xv"
  echo "        ]"
  echo "        project_name = 'minemeld_synthetic_core'"
  echo "        project_version = '1.0'"
  echo "        python_version = '2.7'"
  echo "        dist = pkg_resources.Distribution("
  echo "            location='/tmp/{}-{}-py{}.egg'.format(project_name, project_version, python_version),"
  echo "            project_name=project_name,"
  echo "            version=project_version,"
  echo "            py_version=python_version"
  echo "        )"
  echo "        node_map = {'minemeld_nodes': node_endpoints}"
  echo "        dist._ep_map = pkg_resources.EntryPoint.parse_map(node_map, dist)"
  echo "        ws.add(dist)"
  echo "    except (KeyError, OSError):"
  echo "        pass"
  echo ""
  echo ""
  echo "if __name__ == '__main__':"
  echo "    WS = pkg_resources.WorkingSet()"
  echo "    _initialize_default_nodes_distribution(WS)"
  echo "    setattr(sys.modules['minemeld.loader'], '_WS', WS)"
  echo "    setup()"
  echo "    main()"
) >minemeld/cli/engine.py
(
  echo "from init import setup"
  echo "from minemeld.flask.main import app"
  echo ""
  echo ""
  echo "if __name__ == '__main__':"
  echo "    setup()"
  echo "    app.run(threaded=True)"
) >minemeld/cli/web.py
(
  echo "from init import setup"
  echo "from minemeld.traced.main import main"
  echo ""
  echo ""
  echo "if __name__ == '__main__':"
  echo "    setup()"
  echo "    main()"
) >minemeld/cli/traced.py
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

1.6. Setup password files:

```
htpasswd -bc $w/minemeld-docker/minemeld.d/api/wsgi.htpasswd admin minemeld
cat </dev/null >$w/minemeld-docker/minemeld.d/api/feeds.htpasswd
```

1.7. Build and start the docker-based services:

```
docker-compose build
docker-compose up collectd rabbitmq redis
```

1.8. Debug the "engine" target

1.9. Debug the "web" target

1.10. Debug the "traced" target

2. Setup minemeld-webui

2.1 Install tools
```
brew install nodeenv
```

2.2. Setup python, needed for compiling the node packages
```
cd $w/minemeld-webui
echo 2.7.15 >.python-version
echo .python-version >> .gitignore
mkdir -p ../pyenv
virtualenv ../pyenv/minemeld-webui
. ../pyenv/minemeld-webui/bin/activate
```

2.3. Setup node runtime
```
mkdir -p ../nodeenv
nodeenv -v -n 4.2.6 --npm=2.14.7 --prebuilt -c ../nodeenv/minemeld-webui
. ../nodeenv/minemeld-webui/bin/activate
npm install
PATH=$(npm bin):$PATH
bower install
typings install
nsp check
gulp build
```

2.4. Configure WebStorm minemeld-webui project with ../nodeenv/minemeld-webui

On the "WebStorm>Preferences>Languages & Frameworks>Node.js and NPM" page, add a new local node interpreter

2.5. Open the Gulp tools window

Click "View>Tool windows>Gulp"

2.6. Setup the "serve" target

Right click on the "serve" Gulp target
Click "Edit 'serve' settings..."
Set arguments to: --url http://127.0.0.1:5000

2.7. Setup the "webui" target

Click "Run>Edit Configurations..."
Click "+>JavaScript Debug"
Set name to "webui"
Set URL to "http://localhost:3000"

2.8. Debug the "serve" target

2.9. Debug the "webui" target

2.10. Command line testing
```
cd $w/minemeld-webui
. ../pyenv/minemeld-webui/bin/activate
. ../nodeenv/minemeld-webui/bin/activate
PATH=$(npm bin):$PATH
gulp serve --url http://127.0.0.1:5000
```
