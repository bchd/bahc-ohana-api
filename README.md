# BCHD CHARMcare

CHARMcare is an application to help Baltimore residents find local services.

It is based off of [Ohana API](https://github.com/codeforamerica/ohana-api).

## Stack Overview

* Ruby version 3.2.2
* Rails version 7
* PostgreSQL 14
* Elasticsearch version 7

## Setup

Install PostgreSQL through [Postgres.app](https://postgresapp.com/). Make sure to have **PostgreSQL 14** or higher.

Start Elasticsearch via docker with the following command:

```bash
docker run --rm --name elasticsearch7 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "xpack.security.enabled=true" -e "ELASTIC_PASSWORD=password"  elasticsearch:7.17.0
```

Install [the nix package manager](https://nixos.org/download.html#nix-install-macos) by following their multi-user installer. Once nix is installed, setup [direnv](https://direnv.net/) by hooking into your shell.

```bash
nix-env -f '<nixpkgs>' -iA direnv
echo '\n\neval "$(direnv hook zsh)"' >> ~/.zshrc
```

Once direnv is installed and your shell is restarted, clone the project and `cd` into it. You should see direnv warn about an untrusted `.envrc` file. Allow the file and finish installing dependencies and setting up the application.

```bash
direnv allow

bundle
rails db:create db:migrate db:test:prepare
yarn install
./bin/dev
```

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser.

## Deploying to Heroku

Heroku will auto deploy the develop and staging branches. Production is updated via a Heroku pipeline promotion.


NOTE: If you've modified the chewy indices you'll need to reset them in every heroku environment

```
heroku run rake chewy:reset -a APP_NAME
```

### Bucketeer / S3

In order for direct uploads to S3 to work, we need to set the policy on the bucketeer bucket to allow for our URLs.

```bash
aws s3api put-bucket-cors --bucket bucketeer-[id] --cors-configuration file://bucketeer-cors.json
```

## Running the tests

Run tests locally with this simple command:

```bash
rspec
```

## Copyright

Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-api/blob/master/LICENSE.md) for details.
