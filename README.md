# BCHD CHARMcare

CHARMcare is an application to help Baltimore residents find local services.

It is based off of [Ohana API](https://github.com/codeforamerica/ohana-api).

## Stack Overview

* Ruby version 2.7.5
* Rails version 5.1.6
* PostgreSQL
* Elasticsearch version 5.6

## Setup

Install PostgreSQL through [Postgres.app](https://postgresapp.com/). Make sure to have **PostgreSQL 12** or above.

Install [the nix package manager](https://nixos.org/download.html#nix-install-macos) by following their multi-user installer. Once nix is installed, setup [direnv](https://direnv.net/) by hooking into your shell.

```bash
nix-env -f '<nixpkgs>' -iA direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
```

Once direnv is installed and your shell is restarted, clone the project and `cd` into it. You should see direnv warn about an untrusted `.envrc` file. Allow the file and finish installing dependencies and setting up the application.

```bash
direnv allow

bundle
rails db:create db:migrate db:test:prepare
yarn install
rails server
```

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser.

## Deploying to Heroku

Set your heroku remotes for each app appropriately, `dev` for the development app, `staging` for the staging app, and `prod` for the production app.

NOTE: If you've modified the chewy indices you'll need to reset them in every heroku environment manually likeso:

```
heroku run rake chewy:reset -a prod-ahc-ohana-api
```

```bash
# Deploy Development
git push dev develop:main

# Deploy Staging
git push staging staging:main

# Deploy Production
git push prod main
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
