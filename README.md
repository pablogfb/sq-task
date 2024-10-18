# README

## Details

This is an agnostic Rails 7 app with postgress as database and rspec for running tests

## Setup

This application is prepared to be used with docker and docker compose. It uses ruby 3.3.5-slim and posgress:14.2 images.

Prepare `.env`file following `.env.example`model.

Then build the docker image:
`docker compose build`

Create the database:
`docker compose run web db:create`

Run migrations:
`docker compose run web db:migrate`


# Run the app

Launch the app:
`docker compose up`


## Run test

Execute:
`docker compose run web rspec`