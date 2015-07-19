# service-proxy

This container uses consul-template to automatically configure an haproxy to proxy to consul services.

To use, launch via marathon and specify the follwing env vars:

SERVICE_NAME: Name of the service you want to proxy to.

SERVICE_ENV: Env of the service you want to proxy to.
