# Technovation Challenge Platform

### Technovation is a global tech education nonprofit that empowers girls to become leaders, creators and problem-solvers.

QA: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/qa)

Master: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/master)

Production: [![CircleCI](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production.svg?style=svg&circle-token=2761348ab1cf794859c6cc40536654b342a8a9d1)](https://circleci.com/gh/Iridescent-CM/technovation-app/tree/production)

[![We are using BrowserStack for cross-browser compatibility](https://s3.amazonaws.com/technovation-uploads-production/header-logo.png "BrowserStack")](https://www.browserstack.com/)

We use BrowserStack to [test for cross-browser compatibility](https://www.browserstack.com/) so that we can support a worldwide community of volunteers!

## Rails Docs:
[Rails 7 documentation](https://guides.rubyonrails.org/v7.0/)

## Installation and Setup

### Prerequisites

#### macOS

Install homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install asdf, ruby 3.1.2, nodejs <latest-version>

```
brew install asdf

asdf plugin-add ruby
asdf plugin-add nodejs

asdf install ruby 3.1.2
asdf install nodejs <latest-version>
```

Make sure XCode is installed.

Under Xcode preferences locations, make sure there is a version set.

Install redis  (follow the post-install instructions)

```
brew install redis
```

Install postgresql (follow the post-install instructions)

```
brew install postgresql
createuser -s postgres
```

Install imagemagick

```
brew install imagemagick
```

Install pdftk

[https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg)

Install wkhtmltopdf

[Install as appropriate](https://github.com/pdfkit/pdfkit/wiki/Installing-WKHTMLTOPDF) for your environment, and make sure to set `WKHTMLTOPDF_PATH` in your .env file to point to the tool.
### Install the rails application

```
git clone git@github.com:Iridescent-CM/technovation-app.git
```

For the most up-to-date ENV settings, copy them from the Heroku QA envirnoment.

Switch to ruby 3.1.2 (this creates the `.tool-versions` file and you won't have to do it again)
Switch to nodejs <latest-version>
```
asdf local ruby 3.1.2
asdf local nodejs <latest-version>
```

Run the rails setup file

```
./bin/setup
```

Ensure the test suite can run without errors:

```
rake
```

Run the local server

```
rails s
```

Navigate to [http://localhost:3000](http://localhost:3000)

To compile and hot reload assets, run the following in a new terminal window

```
./bin/shakapacker-dev-server
```

## Docker

You can run the app with **Docker Compose** instead of installing Ruby, Node, Postgres, and Redis locally. The stack uses `Dockerfile` at the repo root and `docker-compose.yml`.

### What runs

| Service   | Role |
|-----------|------|
| `web`     | Rails server on port **3000** (source mounted from your machine) |
| `worker`  | Sidekiq (`default` and `mailers` queues) |
| `postgres` | PostgreSQL **14**; user/password `postgres` / `postgres` |
| `redis`   | Redis **7** |

Compose sets `DATABASE_URL`, `REDIS_URL`, `RAILS_ENV`, `RACK_ENV`, and `WKHTMLTOPDF_PATH` for the app containers. You still need a **`.env`** file in the project root for other secrets and config (same as the native setup above).

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with Compose (v2: `docker compose`).

### First-time setup

1. Clone the repo and place `.env` in the project root.
2. Build and start everything:

   ```
   docker compose up --build
   ```

3. In another terminal, prepare the database (migrations, etc.) once:

   ```
   docker compose exec web bundle exec rails db:prepare
   ```

   Add seed data if your team uses it:

   ```
   docker compose exec web bundle exec rails db:seed
   ```

Open [http://localhost:3000](http://localhost:3000). Postgres is also published on **5432** and Redis on **6379** on localhost if you need them from tools outside Docker.

### Image details (`Dockerfile`)

- Base image: **Ruby 3.4.9** (slim), aligned with the `Gemfile` Ruby version.
- **Node 26** and Yarn for the front end; `bundle install` and `yarn install` run at build time.
- System packages include build tools, `libpq`, ImageMagick, `pdftk-java`, wkhtmltopdf (amd64/arm64), and libraries used by native gems (e.g. node-canvas).
- Default image command (without Compose overriding it) runs `rails db:prepare` then `rails s` on `0.0.0.0:3000`. Ports **3000** and **3035** are declared for the app and Webpack dev server.

### Compose behavior

- **`web`** mounts the repo at `/app` with a named volume for Bundler (`bundle`) and another for `node_modules` so installs persist between runs.
- **`worker`** uses the same image and volumes and connects to the same DB and Redis.
- **`postgres`** uses a healthcheck so `web` and `worker` start after the DB is ready.

### Assets in Docker

For Webpack dev server with hot reload, run it inside the `web` container and publish port **3035** (add `3035:3035` under `web.ports` in `docker-compose.yml` if it is not already there), then:

```
docker compose exec web ./bin/shakapacker-dev-server -b 0.0.0.0
```

### Builds and secrets (`.dockerignore`)

`.dockerignore` keeps `.env` and other local files out of the **image build context** so secrets are not baked into layers. With Compose, your working tree is still bind-mounted into `/app`, so the app reads `.env` from the host at runtime.

## User type logins:

Seeded users:

* Student
  * username: student@student.com
  * password: student@student.com

* Mentor
  * username: mentor@mentor.com
  * password: mentor@mentor.com

* Judge
  * username: judge@judge.com
  * password: judge@judge.com

* Chapter Ambassador
  * username: chapter-ambassador@chapter-ambassador.com
  * password: chapter-ambassador@chapter-ambassador.com

* Admin
  * username: admin@admin.com
  * password: admin@admin.com

## To turn on/off various user features:

  * Login as the admin
  * Go to "Content & Settings"
  * Toggle what you need on or off


## Tests

Technovation uses RSpec, and you can run the entire test suite just by entering the command `rake`

```
rake
```

### JavaScript tests

Plain JS modules and Vue components are tested with [Vitest](https://vitest.dev/) and [@vue/test-utils](https://v1.test-utils.vuejs.org/) (Vue 2 line). Tests live in `spec/javascript/`, mirroring the structure of `app/javascript/`.

```bash
yarn test          # run once (CI mode)
yarn test:watch    # watch mode for local development
```

The test tooling is intentionally pinned to Vue 2.6-compatible versions (`vitest@0.34.6`, `vite@4`, `vite-plugin-vue2`) as devDependencies only — production dependencies (including `vue@2.6.11`) are unchanged.

Current coverage focuses on critical-path business logic:

- Age/division cutoff helpers (`utilities/age-helpers`)
- Judge scoring completeness rules (Vuex getters/actions)
- Registration readiness and profile validation (Vuex getters)
- Key Vue components: `ScoreEntry`, `QuestionSection`, `BasicProfile`, `LocationForm`

JS unit tests run in CircleCI on parallel node 0, after ESLint and before the database setup step.
