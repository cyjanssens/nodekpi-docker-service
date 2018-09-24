# nodekpi-docker-service

Docker compliant nodepki implements.

Download and build images.

```
# cd api && docker build -t nodepki-api:7.0 .
# cd ../weblient && docker build -t nodepki-webclient:7.0 .
```

Now adapt docker-compose.yml with your values and compose:

```
# docker-compose up
```

Default web client config : http://localhost:5000

