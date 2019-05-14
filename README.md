[![CircleCI](https://circleci.com/gh/PinsterTeam/PinsterApi.svg?style=shield)](https://circleci.com/gh/PinsterTeam/PinsterApi)
[![Maintainability](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/maintainability)](https://codeclimate.com/github/PinsterTeam/PinsterApi/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/test_coverage)](https://codeclimate.com/github/PinsterTeam/PinsterApi/test_coverage)

# PinsterApi

The api that brings the bacon home.



# Deployment

Checklist

1. Generate new `OpenSSL::PKey::RSA.generate(2048)` keys for image service and pinster api.
1. Set environment variables in elasticbeanstalk configure thing.
1. Set environment variables in secrets manager for image service's keys


# .env setup

```dotenv
AUTH0_SITE=AUTH0_SITE_url
JWT_AUD=hosted_address
```


Things to remember for prod push:
1. run on ec2 instance
    ```ruby
          PgSearch::Multisearch.rebuild(Pin, true)
          PgSearch::Multisearch.rebuild(Assortment, true)
    ```

1. Set these envs:
    ```dotenv
    AUTH0_SITE=
    JWT_AUD=
    SWAGGER_HOST=
    SEED_USER_ID=
    RDS_DB_NAME=
    RDS_HOSTNAME=
    RDS_PASSWORD=
    RDS_PORT=
    RDS_USERNAME=
    SECRET_KEY_BASE=
    ```
1. Set up auth0