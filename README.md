# 5xRuby - Training Program

## Version:

- Ruby: 2.7.2
- Rails: 6.1.3.2

## Table Schema

- Model: User

| Column | Type | Explanation |
| ------ | ---- | ----------- |
| email | string | 帳號 |
| password | string | 密碼 |
| role | string | 角色 |

- Model: Mission

| Column | Type | Explanation |
| ------ | ---- | ----------- |
| title | string | 標題 |
| content | string | 內容 |
| tag | string | 標籤 |
| status | string | 狀態 |
| priority | integer | 優先順序 |
| start_at | datetime | 開始時間 |
| end_at | datetime | 結束時間 |

## Deploy

### Heroku

1. [Sign up](https://www.heroku.com/) an heroku account
2. Install [Heroku Cli](https://devcenter.heroku.com/articles/heroku-cli#standalone-installation)
3. Check if successfully installed
  - `$ heroku -v` to check the version
  - `$ heroku` to see all commands
  ```
  CLI to interact with Heroku

VERSION
  heroku/7.53.1 linux-x64 node-v12.21.0

USAGE
  $ heroku [COMMAND]

COMMANDS
  access          manage user access to apps
  addons          tools and services for developing, extending, and operating your app
  apps            manage apps on Heroku
  auth            check 2fa status
  authorizations  OAuth authorizations
  autocomplete    display autocomplete installation instructions
  buildpacks      scripts used to compile apps
  certs           a topic for the ssl plugin
  ci              run an application test suite on Heroku
  clients         OAuth clients on the platform
  config          environment variables of apps
  container       Use containers to build and deploy Heroku apps
  domains         custom domains for apps
  drains          forward logs to syslog or HTTPS
  features        add/remove app features
  git             manage local git repository for app
  help            display help for heroku
  keys            add/remove account ssh keys
  labs            add/remove experimental features
  local           run Heroku app locally
  logs            display recent log output
  maintenance     enable/disable access to app
  members         manage organization members
  notifications   display notifications
  orgs            manage organizations
  pg              manage postgresql databases
  pipelines       manage pipelines
  plugins         list installed plugins
  ps              Client tools for Heroku Exec
  psql            open a psql shell to the database
  redis           manage heroku redis instances
  regions         list available regions for deployment
  releases        display the releases for an app
  reviewapps      manage reviewapps in pipelines
  run             run a one-off process inside a Heroku dyno
  sessions        OAuth sessions
  spaces          manage heroku private spaces
  status          status of the Heroku platform
  teams           manage teams
  update          update the Heroku CLI
  webhooks        list webhooks on an app
  ```
4. `$ heroku login` to sign in your heroku account
5. `$ heroku create your_project_name` to create an heroku app
6. `$ git push heroku branch_name:main` to deploy your project to heroku

## Steps

1. $ bundle install
2. $ yarn install
3. $ rails db:create
4. $ rails db:migrate
5. $ mv application.yml.sample application.yml
6. set the environment variables in `application.yml` file
7. $ foreman s -f Procfile.dev

