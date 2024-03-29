# videocall

## App Getting Started

#### Requirements

You'll need the following installed to run the template successfully:

- Ruby 2.5 or higher
- bundler - `gem install bundler`
- rails - `gem install rails`
- Database - we recommend Postgres, but you can use MySQL, SQLite3, etc
- Redis - For ActionCable & Sidekiq support
- ImageMagick or libvips for ActiveStorage variants
- Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)
- Foreman global (optional) - `gem install foreman` - helps run all your processes in development

### Factory Bot for RSpec

- Place "config.include FactoryBot::Syntax::Methods" in RSpec.config (/spec/rails_helper) & uncomment Dir join line, comment out the fixture line.

### Default generators

- application.rb - generators, optional values placed as below, amend/add others as needed

config.generators do |g|
g.orm :active_record
g.orm :active_record, primary_key_type: :uuid
g.orm :active_record, foreign_key_type: :uuid
g.template_engine :erb
g.test_framework :rspec, fixture: false
g.fixture_replacement :factory_bot, dir: 'spec/factories'
g.stylesheets false
g.javascripts false
g.helper false
g.system_tests nil
end

### Default is int8 ID's - To use UUIDs in current migration files

- After setup complete, check above generators are set, In current migration files, for UUIDs, ensure uncommented config generator lines, place lines in all migrations as below:

- create table lines: insert after the table name: ", id: :uuid" # minus quotes, sets Primary key uuid
- foreign_key lines: append: ", type: :uuid" # minus quotes, sets Foreign key uuid

$ rails db:migrate:reset

- All future models will have UUIDs on creation

### DB seed example

    User.create(
    email:  Faker::Internet.email,
    password: Faker::Internet.password,
    first_name:  Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    admin: false,
    announcements_last_read_at: Time.current

)

##### Recommended To have globally per ruby version for use in projects and templates (dont forget rehash if rbenv)

gem install foreman
gem install bundler-audit
gem install lefthook
gem install ransack (esp if template not complete properly)
gem install spreadsheet_architect (esp if template not complete properly)

❓Having trouble? Try adding `DISABLE_SPRING=1` before `rails new`. Spring will get confused if you create an app with the same name twice, and 'bundle clean --force' if any gem conflicts.

#### For Rails 6 remember to alter load defaults line in application.rb from 7.0 to 6.0

#### Running your app

```bash
bin/dev
```

You can also run them in separate terminals manually if you prefer.

A separate `Procfile` is generated for deploying to production on Heroku.

#### Active Interaction

[https://github.com/aaronlasseigne/active_interaction]

- Setup
  We recommend putting your interactions in app/interactions. It's also very helpful to group them by model. That way you can look in app/interactions/accounts for all the ways you can interact with accounts.

* app/
  - controllers/
    - accounts_controller.rb
  - interactions/
    - accounts/
      - create_account.rb
      - destroy_account.rb
      - find_account.rb
      - list_accounts.rb
      - update_account.rb
  - models/
    - account.rb
  - views/
    - account/
      - edit.html.erb
      - index.html.erb
      - new.html.erb
      - show.html.erb

#### Authenticate with social networks

We use the encrypted Rails Credentials for app_id and app_secrets when it comes to omniauth authentication. Edit them as so:

```
EDITOR=nano rails credentials:edit
```

Make sure your file follow this structure:

```yml
secret_key_base: [your-key]
development:
  github:
    app_id: something
    app_secret: something
    options:
      scope: "user:email"
      whatever: true
production:
  github:
    app_id: something
    app_secret: something
    options:
      scope: "user:email"
      whatever: true
```

With the environment, the service and the app_id/app_secret. If this is done correctly, you should see login links
for the services you have added to the encrypted credentials using `EDITOR=vim rails credentials:edit`

##### Multi Tenant support/usage

Based on [https://dev.to/kolide/a-rails-multi-tenant-strategy-thats-30-lines-and-just-works-58cd]

Base files already in place when generate app.

To use, when making a new model, add an account_id column into it for use in a multi tenancy setup (integer or uuid depending on your setup)
and: include AccountOwnable in the model (not the User model)

Console Examples:

- Create an account in console acc = Account.create(name: "Global") - will get an id which can be used in subsequent models account_id column.

- reload!

- Current.account=1 (or uuid no if uuids)

- t 1 to switch to tenant id 1

Read article for more tips

#### Redis set up

##### On OSX

```
brew update
brew install redis
brew services start redis
```

##### Ubuntu

```
sudo apt-get install redis-server
```

#### Cleaning up

```bash
rails db:drop
spring stop
cd ..
rm -rf myapp
```
