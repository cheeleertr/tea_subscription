# Tea Subscription Service API

This is a Rails API for a Tea Subscription Service. The API allows customers to subscribe to various tea subscriptions, manage their subscriptions, and view all active and cancelled subscriptions. The service includes features like adding new subscriptions, canceling subscriptions, and listing all subscriptions for a customer.

 [Database Diagram](https://dbdiagram.io/d/66493e60f84ecd1d228ada49)


## Getting Started

These instructions will help you set up and run the project on your local machine for development and testing purposes.

### Prerequisites

Ensure you have the following software installed:

- Ruby 3.2.x
- Rails 7.x
- PostgreSQL
- RSpec for testing

### Installing

Follow these steps to set up the development environment:

Fork and Clone the repository:

    git clone git@github.com:cheeleertr/tea_subscription.git

Install dependencies by running this in the terminal:

    bundle install

Set up the database by running these in the terminal:

    rails db:create
    rails db:migrate
    rails db:seed

Run the server:

    rails server

You can now access the API at http://localhost:3000.

## API Endpoints

You can use [Postman](https://www.postman.com/) to test endpoints.

### Subscribe a Customer to a Tea Subscription
POST /api/v1/customers/:customer_id/subscriptions \
Description: Creates a new subscription for a customer.

ex:
POST "http://localhost:3000/api/v1/customers/1/subscriptions"

Request Body:
```
{
  "title": "Monthly Jasmine Tea",
  "price": 10000,
  "status": "active",
  "frequency": 0,
  "tea_id": 1
}
```
Response:
```
{
  "data": {
    "id": 1,
    "attributes": {
      "title": "Monthly Jasmine Tea",
      "price": 10000,
      "status": "active",
      "frequency": "monthly",
      "customer_id": 1,
      "teas": [
        {
          "id": 1,
          "title": "Jasmine Tea"
        }
      ]
    }
  }
}
```
### Cancel a Customer’s Tea Subscription
Endpoint: PATCH /api/v1/customers/:customer_id/subscriptions/:id \
Description: Updates a subscription status to cancelled.

PATCH "http://localhost:3000/api/v1/customers/1/subscriptions/1?status=cancelled" 
```
{
  "data": {
    "id": 1,
    "attributes": {
      "title": "Monthly Jasmine Tea",
      "price": 10000,
      "status": "cancelled",
      "frequency": "monthly",
      "customer_id": 1,
      "teas": [
        {
          "id": 1,
          "title": "Jasmine Tea"
        }
      ]
    }
  }
}
```
### Get All Subscriptions for a Customer
Endpoint: GET /api/v1/customers/:customer_id/subscriptions \
Description: Retrieves all of a customer's subscriptions, both active and cancelled.

GET "http://localhost:3000/api/v1/customers/1/subscriptions"

Response:
{
  "data": [
    {
      "id": 1,
      "attributes": {
        "title": "Monthly Jasmine Tea",
        "price": 10000,
        "status": "active",
        "frequency": "monthly",
        "customer_id": 1,
        "teas": [
          {
            "id": 1,
            "title": "Jasmine Tea"
          }
        ]
      }
    },
    {
      "id": 2,
      "attributes": {
        "title": "Weekly Green Tea",
        "price": 5000,
        "status": "cancelled",
        "frequency": "weekly",
        "customer_id": 1,
        "teas": [
          {
            "id": 2,
            "title": "Green Tea"
          }
        ]
      }
    }
  ]
}



## Authors

  - Chee Lee

## Acknowledgments

  - Thanks to the Turing School for the intermission project