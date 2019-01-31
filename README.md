# fb-service-token-cache
A stand-alone microservice providing a REST endpoint from which other Form
Builder platform apps (User Datastore, Submitter) can retrieve service tokens.

The authoritative source for tokens is a wrapper around `kubectl get secret`
calls, which use the `FB_ENVIRONMENT_SLUG` and `KUBECTL_*` environment variables
(see below) to construct the secret name and kubectl parameters. It will cache
successful calls in Elasticache Redis for SERVICE_TOKEN_CACHE_TTL seconds.


# Environment Variables

The following environment variables are either needed, or read if present:

* DATABASE_URL: used to connect to the database
* RAILS_ENV: 'development' or 'production'
* REDIS_URL or REDISCLOUD_URL: if either of these are present, cache tokens in
  Redis at this URL rather than in local files (default). Note that this value
  should not include the protocol
* REDIS_PROTOCOL: "redis://" or "rediss://" (for TLS-enabled Elasticache)
* REDIS_AUTH_TOKEN: authorisation token for the Elasticache connection.
* FB_ENVIRONMENT_SLUG: 'dev', 'staging', or 'production' - which Form Builder
  environment is this running in? This will affect the suffix of the K8s
  secrets & namespaces it will try to read service tokens from
* KUBECTL_BEARER_TOKEN: identifies the ServiceAccount the app will authenticate
  against in kubernetes for kubectl calls
* KUBECTL_CONTEXT: (optional) which kubectl context it will look for secrets in
* SERVICE_TOKEN_CACHE_TTL: expire service token cache entries after this many
  seconds

## To deploy and run on Cloud Platforms

See [deployment instructions](DEPLOY.md)