[![CircleCI](https://circleci.com/gh/IlluminusLimited/PinsterApi.svg?style=shield)](https://circleci.com/gh/IlluminusLimited/PinsterApi)
[![Maintainability](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/maintainability)](https://codeclimate.com/github/IlluminusLimited/PinsterApi/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/test_coverage)](https://codeclimate.com/github/IlluminusLimited/PinsterApi/test_coverage)

# PinsterApi

The api that brings the bacon home.

# Flows

## New pin

1. In auth0 admin control panel make sure user has `create:pin` permission
1. Get an access token from auth0. We'll call it our `auth0_token`
1. POST to `/v1/pins` using your `auth0_token` as a `Bearer` token with a body like so:
    ```json
    {
      "data": {
        "name": "Wisconsin Unicorn",
        "year": 2009,
        "description": "This unicorn was made up, unless it exists. It is a very cool unicorn."
      }
    }
    ```
    Your response will look like:
    ```json
    {
      "id": "3d3987fa-4fb6-4b2d-8980-c1919f5e63ec",
      "name": "Wisconsin Unicorn",
      "year": 2009,
      "description": "This unicorn was made up, unless it exists. It is a very cool unicorn.",
      "tags": [],
      "created_at": "2019-05-15T22:59:01.754Z",
      "updated_at": "2019-05-15T22:59:01.754Z",
      "images_url": "http://www.example.com/v1/pins/3d3987fa-4fb6-4b2d-8980-c1919f5e63ec/images",
      "url": "http://www.example.com/v1/pins/3d3987fa-4fb6-4b2d-8980-c1919f5e63ec"
    }
    ```
1. You're done! You've created a `Pin`! This is the same flow for any other item in the api.


## Add image to existing imageable

Almost everything in PinsterApi is imageable so this process can be applied to `Users`, `Pins`, `Assortments`, and
`Collections`, etc.

1. Do a `GET` (`POST` will have the same data if you're creating a resource) on the resource you'd like to 
add an image to. The `images_url` will be in the response body:
    Example response for a `Pin`:
    ```json
    {
      "id": "3d3987fa-4fb6-4b2d-8980-c1919f5e63ec",
      "name": "Wisconsin Unicorn",
      "year": 2009,
      "description": "This unicorn was made up, unless it exists. It is a very cool unicorn.",
      "tags": [],
      "created_at": "2019-05-15T22:59:01.754Z",
      "updated_at": "2019-05-15T22:59:01.754Z",
      "images_url": "http://www.example.com/v1/pins/3d3987fa-4fb6-4b2d-8980-c1919f5e63ec/images",
      "url": "http://www.example.com/v1/pins/3d3987fa-4fb6-4b2d-8980-c1919f5e63ec"
    }
    ```
    1. Note, the `images_url` isn't special, it's just in the response for your convenience. All imageables have a 
    `/images` route on which you can do `GET` and `POST`.
    
1. Parse response for the `images_url`
1. `POST` to `images_url` without a `body` using your `auth0_token` as a `Bearer` token.
   Your response will look like this:
   ```json
   {
     "image_service_token": "eyJhbGciOiJSUzI...",
     "image_service_url": "http://images.example.com"
   }
    ```
    1. Note: These tokens are specific to the imageable and will expire shortly after they are generated 
    (10 minutes or so). All images uploaded to image service with this token will be attached to the imageable 
    for which this token was generated.
    
1. Parse response for the `image_service_token` and `image_service_url`
1. POST to `image_service_url` using the `image_service_token` as a `Bearer` token with a body like so:
    ```json
    {
      "data": {
        "image": "base64 encoded image",
        "name": "Optional name of image",
        "description": "Optional description",
        "featured": "Optional ISO8601 format"
      }
    }
    ```
    Your response will look like this but you don't have to parse this:
    ```json
    {
      "bucket": "image-service-upload-dev.pinster.io",
      "key": "raw/d01834089090031b1c7d098882cfb41b",
      "message": {
        "ETag": "\"d01834089090031b1c7d098882cfb41b\""
      }
    }
    ```

1. Image service will process your image and if it passes moderation it will `POST` back to the api
    on your behalf, linking the image to your imageable (pin in this case)!


# Deployment

Checklist

1. Generate new `OpenSSL::PKey::RSA.generate(2048)` keys for image service and pinster api.
    Use `rails generate_keys` and the `keys.env` file will contain urlsafe base64 encoded keys
    for use in environment variables.
1. Set environment variables in elasticbeanstalk configure thing.
1. Set environment variables in secrets manager for image service's keys

1. run on ec2 instance
    ```ruby
          PgSearch::Multisearch.rebuild(Pin, true)
          PgSearch::Multisearch.rebuild(Assortment, true)
    ```

1. Set these envs:
    ```dotenv
    SWAGGER_HOST=
    RDS_DB_NAME=
    RDS_HOSTNAME=
    RDS_PASSWORD=
    RDS_PORT=
    RDS_USERNAME=
    SECRET_KEY_BASE=
    AUTH0_SITE=
    JWT_AUD=
    IMAGE_SERVICE_URL=
    PRIVATE_KEY=
    IMAGE_SERVICE_PUBLIC_KEY=
    ```
1. Set up auth0