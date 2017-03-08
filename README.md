# Dailyreport41

Create daily report easier with simple interface.

## Technologies

* [Ruby](https://www.ruby-lang.org/) version **2.3.1**
* [Ruby on Rails](http://rubyonrails.org/) version **4.2.8**
* [PostgreSQL](http://www.postgresql.org/) version **9.6**
* [RailsAdmin](https://github.com/sferik/rails_admin)
* [Flat Admin V3.0](https://github.com/tui2tone/flat-admin-bootstrap-templates)
* [Haml-rails](https://github.com/indirect/haml-rails)
* [Mustache](https://github.com/mustache/mustache)
* [OmniAuth Google OAuth2 Strategy](https://github.com/zquestz/omniauth-google-oauth2)
* [Google API Client](https://github.com/google/google-api-ruby-client)
* [Gmail for Ruby](https://github.com/gmailgem/gmail)

## Features
* Login with Google account
* Create project
* Create report
* Send email report as your Google account
* Recap reports (for manager)

## Installation to local computer

* Clone dailyreport41 to your local machine
```bash
$ git clone git@github.com:41studio/dailyreport41.git
```
* Rename database config in **config/database.yml.example** to **database.yml** and change config username, password and database name.
* Rename env variable config in **.env.example** to **.env** and set your variables.
* Then bundle install
```bash
$ bundle install
```
* Create database
```bash
$ rake db:create
```
* Run migration
```bash
$ rake db:migrate
```
* Run the server
```bash
$ rails s
```
