1. Make .../minemeld-core/minemeld/run/launcher.py executable by adding
```
if __name__ == '__main__':
    main()
```

2. Configure a launcher as follows:

Script path: .../minemeld-core/minemeld/run/launcher.py
Parameters: .../minemeld-docker/minemeld.d
Environment variables:
  - MINEMELD_PROTOTYPE_PATH=.../minemeld-node-prototypes/prototypes
  - PYTHONUNBUFFERED=1
  - OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
Working directory: minemeld-docker/minemeld.d

3. Build and start the docker-based services:

```
cd .../minemeld-docker/collectd
docker build -t collectd:sddj .
cd ..
docker-compose up collectd rabbitmq redis
g```

4. Start the service to expose the collectd socket outside the container:

```
.../minemeld-docker/bin/collectd-push
```

5. Debug
