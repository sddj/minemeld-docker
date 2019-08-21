1. Setup minemeld-core  
    1. You need leveldb to install the plyvel Python package and rrdtool for the rrdtool Python package
        ```
        brew install leveldb rrdtool nodeenv
        ```
    2. Make wrappers for the PyCharm debugger:
        ```
        cd $w/minemeld-docker
        bin/setup-minemeld
        ```
    3. Configure the PyCharm minemeld-core project with the custom Python environment  
        On the "PyCharm>Preferences...>Project: minemeld-core>Project Interpreter" page, click the settings gear
        and "Add..." a new Project Interpreter.  Choose "Virtual Environment>Existing environment" and set the
        Interpreter to ```${w}/pyenv/minemeld-core/bin/python```
    4. Setup the "traced" debug target:  
        <table>
        <tr><td>Script path</td><td>$w/minemeld-core/minemeld/cli/traced.py</td></tr>
        <tr><td>Parameters</td><td>traced.yml</td></tr>
        <tr><td>Environment variables</td><td>PYTHONUNBUFFERED=1</td></tr>
        <tr><td>Working directory</td><td>$w/minemeld-docker/minemeld.d</td></tr>
        </table>
    5. Setup the "engine" debug target:
        <table>
        <tr><td>Script path</td><td>$w/minemeld-core/minemeld/cli/engine.py</td></tr>
        <tr><td>Parameters</td><td>.</td></tr>
        <tr><td>Environment variables</td><td>PYTHONUNBUFFERED=1<br/>
                                    OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES<br/>
                                    MINEMELD_PROTOTYPE_PATH=../../minemeld-node-prototypes/prototypes<br/>
                                    MINEMELD_NODES_PATH=../../minemeld-core/nodes.json</td></tr>
        <tr><td>Working directory</td><td>$w/minemeld-docker/minemeld.d</td></tr>
        </table>
    6. Setup the "web" debug target:  
        <table>
        <tr><td>Script path</td><td>$w/minemeld-core/minemeld/cli/web.py</td></tr>
        <tr><td>Parameters</td><td>.</td></tr>
        <tr><td>Environment variables</td><td>PYTHONUNBUFFERED=1<br/>
                                              MM_CONFIG=.<br/>
                                              MINEMELD_LOCAL_PATH=../shared.d<br/>
                                              API_CONFIG_LOCK=./api/api-config.lock<br/>
                                              REDIS_URL=redis://127.0.0.1:10001/0</td></tr>
        <tr><td>Working directory</td><td>$w/minemeld-docker/minemeld.d</td></tr>
        </table>
    7. Configure PyCharm for gevent compatible debugging.  On "PyCharm>Preferences...>Build,
       Execution, Deployment>Python Debugger", ensure that "Gevent compatible" is checked.
    7. Build and start the docker-based services:
        ```
        docker-compose build
        docker-compose up
        ```
    8. Start debugging using the "traced" target
        Run>Debug...>traced
    9. Start debugging using the "engine" target
        Run>Debug...>engine
    10. Start debugging using the "web" target
        Run>Debug...>web
2. Setup minemeld-webui
    1. Configure the WebStorm minemeld-webui project with the custom Node.js environment  
        On the "WebStorm>Preferences>Languages & Frameworks>Node.js and NPM" page, click the "..." at the right of
        the Node interpreter line, then click "+>Add Local..." and add ```${w}/nodeenv/minemeld-webui/bin/node``` 
    2. Setup the "serve" target  
        1. Click "View>Tool windows>Gulp" to open the Gulp tools window
        2. Right click on the "serve" Gulp target  
        3. Click "Edit 'serve' settings..."  
        4. Set arguments to: --nobrowser --url http://127.0.0.1:5000
    3. Setup the "webui" target
        1. Click "Run>Edit Configurations..."  
        2. Click "+>JavaScript Debug"  
        3. Set name to "webui"  
        4. Set URL to "http://localhost:3000"
    4. Start debugging using the "serve" target
    5. Start debugging using the "webui" target
    6. Alternatively, you can use command line testing
        ```
        cd $w/minemeld-webui
        . ../pyenv/minemeld-webui/bin/activate
        . ../nodeenv/minemeld-webui/bin/activate
        PATH=$(npm bin):$PATH
        gulp serve --url http://127.0.0.1:5000
        ```
