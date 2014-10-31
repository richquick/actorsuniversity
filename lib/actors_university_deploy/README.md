Usage
======

```bash
./bin/deploy staging|health
```


The aim of this set of deploy scripts was to be able to do continuous
deployment to heroku and easily deploy to the various servers.

Aims
----

* Enable tagging of successful builds by semaphore
* Enable compiling of assets and deploying to staging from semaphore
* Enable a one-command deployment of the latest successful build to a production server


Honestly, I've not been using it, as we didn't iron out the issues with it,
so it may make sense to delete this whole gem.
