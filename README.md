# README

## Details

### seQura assigment

Conding challenge for seQura Senior Backend developer application

#### Summary:

seQura provides e-commerce shops with a flexible payment method that allows shoppers to split their purchases in three months without any cost. In exchange, seQura earns a fee for each purchase.

When shoppers use this payment method, they pay directly to seQura. Then, seQura disburses the orders to merchants with different frequencies and pricing.

#### Requirements:

- All orders must be disbursed precisely once.
- Each disbursement, the group of orders paid on the same date for a merchant, must have a unique alphanumerical reference.
- Orders, amounts, and fees included in disbursements must be easily identifiable for reporting purposes.

## Setup

This application is prepared to be used with docker and docker compose. It uses ruby 3.3.5-slim and posgress:14.2 images.

Prepare `.env`file following `.env.example` model.

Then build the docker image:

`docker compose build`

Create the database:

`docker compose run web bundle exec rake db:create`

Run migrations:

`docker compose run web bundle exec rake db:migrate`


### Run the app

Launch the app:

`docker compose up`


## Run tests

Prepare `docker-test/.env`file following `.env.example`model.

Execute:
```
docker compose -f docker-compose.test.yml build
docker compose -f docker-compose.test.yml run web bundle exec rake db:create
docker compose -f docker-compose.test.yml run web bundle exec rake db:migrate
docker compose -f docker-compose.test.yml run web bundle exec rspec
```

A group of 40+ tests has been created to cover the core functionality of the application, including data structure, validations, and methods. These tests provide a foundational assessment of key areas. Depending on the final use cases, additional tests may be needed to address specific edge cases.

# Technical choices

## Stack

This is the tech stack used for this task:

- Ruby (3.3.5) on Rails (~> 7.2.1): Powerful, versatile and quick to build with
- Postgress (14.2): Reliable and widely used relational DB, perfect match for Rails and Active Record
- Rspec for testing
- Periodic tasks handled with system crons through Whenever gem
- Sidekiq + Redis for handling tasks as background jobs for performance and encapsulating 

NOTE: Sidekiq Enterprise has integrated periodic jobs handling which could remove the Whenever need.

## Data structure

I have taken a few decisions motivated by the fact that we are dealing with money. The data structure is
composed by 3 models (Merchant, Order, Disbursement) and their relationships.

- Merchant has many Orders and Disbursements
- Order belongs to one Merchant and one Disbursement
- Disbursement belongs to one Merchant and has one Disbursement.

I decided to use classical IDs as primary keys for DB performance (this would later suppose a bit of headache
on sample that importing).

Usualy it isn't a good idea to store calculated data but we are dealing with money and we need a very high reliability
and quick searching.

I have added some flags like `disbursed: boolean`or `disbursed_at: timestamp` for faster quering.

Order model includes `amount` and calculated `disbursed_fee`. In the future the fee rates could be modified so it is a good
idea to store the actual fee charged to the merchant.

Same for Disbursement model, why include `disbursed_amount` and `fee_amount` when they could be calculated? To ensure data
persistance independently of future changes. Depending on other requirements it could be wise to store that data in one `log` object field instead.

All money fields are handled in cents instead of euros to make all the operations more reliables.

## Data handling and assumptions

Following the instructions, weekly disbursements would be done on live_on + 7.days and so on. This could lead to orders being processed on the following months. As the minimum monthly fee is checked against the monthly disbursements, a fee adjustment could be charged despite the actual monthly orders fullfiling the minimum.

Depending of the terms and conditions would be possible to check the minimum monthly fee against the orders, too. (Another good reason to keep the fees there too).

# Sample data

## Load data
To load the provided sample data you have to run the following commands after app setup:

`docker compose run web bundle exec rake db:seed`

This will load `db/merchants.csv` and `db/orders.csv`on the DB. 

The merchant one is loaded one by one as it only has 50 lines. The second one is trickier because there are 1.3M+ orders and they are referenced to merchants through a string and we use IDs for performance, doing it in the same way would take ours. The script is done in raw SQL, first creating a temporary table, filling it with the csv data and then copying it in the Orders table matching the merchant_reference field with the ID from the merchants table. 

## Processing data

Run the following command to process the sample data and generate disbursements as if it was done in the past:

`docker compose run web bundle exec rake tasks:disburse:historical_disbursement`

This would take some time as it goes through each merchant's orders simulating disbursements daily/weekly from their live_on date.

Then run this command to create monthly fee adjustments:

`docker compose run web bundle exec rake tasks:fee_adjustments:historical_monthly_fee_adjustments`

## Showing results

To show the results tabled as requested in the instructions run the following command:

`docker compose run web bundle exec rake tasks:summary:table[2022,2023]`

This will show the following result:

Year | Number of Disbursements | Amount Disbursed | Order Fees | Number of Monthly Adjustments | Amount of Monthly Adjustments |
| :--------: | :--------: | :--------: | :--------: | :--------: | :--------:   
| 2022 | 1512 | 37.509.595,23 € | 339.956,32 €  | 31 | 593,78 € |          
| 2023 | 10358 | 187.977.839,78 € | 1.709.466,58 € | 110 | 1.831,52 €
