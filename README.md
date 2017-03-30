# MiCasa

Welcome to MiCasa code repo.MiCasa is a forked project of a popular crowdfunding project called [Catarse](https://github.com/catarse/catarse).

## Getting started

### Dependencies

To run this project you need to have:

* Ruby 2.3.1

* Rails 4.2

* [postgREST 0.3](https://github.com/begriffs/postgrest/releases/tag/v0.3.0.3)

* [PostgreSQL 9.4](http://www.postgresql.org/)
  * OSX - [Postgres.app](http://postgresapp.com/)
  * Linux - `$ sudo apt-get install postgresql`
  * Windows - [PostgreSQL for Windows](http://www.postgresql.org/download/windows/)

  **IMPORTANT**: Make sure you have postgresql-contrib ([Additional Modules](http://www.postgresql.org/docs/9.3/static/contrib.html)) installed on your system.

### Setup the project

* Clone the project

        $ git clone https://github.com/ToroNZ/MiCasa.git

* Enter project folder

        $ cd MiCasa

* Create the `database.yml`

        $ cp config/database.sample.yml config/database.yml

    You must do this to configure your local database!
    Add your database username and password (unless you don't have any).

* Install the gems

        $ bundle install

* Install the front-end dependencies

        $ bower install

    Requires [bower](http://bower.io/#install-bower), which requires [Node.js](https://nodejs.org/download/) and its package manager, *npm*. Follow the instructions on the bower.io website.

* Create and seed the database

        $ rake db:create db:migrate db:seed

* Configure the API server

	We provide authentication through JWT ([JSON Web Tokens](http://jwt.io/)) and it can be configured by `CatarseSettings` into rails console.

		$ bundle exec rails console
		> CatarseSettings[:api_host] = "http://localhost:3004" # postgREST server url
		> CatarseSettings[:jwt_secret] = "gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr9C" # this token is just a valid example

If everything goes OK, you can now run the project!

### Running the project

* Run API server

	After downloading PostgREST 0.3.x you can unpack and run the executable as below.

		$ ./postgrest postgres://user@localhost/db_name -a anonymous --jwt-secret gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr9C -s 1 -p 3004

* Run Rails server
```bash
$ rails server
```

Open [http://localhost:3000](http://localhost:3000)

### Translations

We are in the process of translating Catarse into Spanish (castellano). It might be a rocky ride so bare with us, I have no idea what I'm doing.

## Payment gateways

We look forward to integrate this solution with Stripe-like methods and some Bank Payment Systems.

## How to contribute with code

Discuss your plans in our Rocket Chat room (https://chat.sensaway.co.nz/channel/general).

After that, just fork the project, change what you want, and send us a pull request.

### Best practices (aka: how to get your pull request accepted faster)

* Follow this style guide: https://github.com/bbatsov/ruby-style-guide
* Create one acceptance tests for each scenario of the feature you are trying to implement.
* Create model and controller tests to keep 100% of code coverage in the new parts you are writing.
* Feel free to add specs to committed code that lacks coverage ;)
* Let our tests serve as a style guide: we try to use implicit spec subjects and lazy evaluation wherever we can.

## License

Licensed under the MIT license (see MIT-LICENSE file)
