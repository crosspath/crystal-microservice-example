# README

An example of a microservice written on [Crystal](https://crystal-lang.org/) and [Lucky framework](https://luckyframework.org).

The idea beside this project is to show, how to create real-life web applications on different languages.  
It will help me to choose better programming language for my needs.

See also this microservice written on other languages:

* [Microservice on Ruby](https://github.com/crosspath/ruby-microservice-example)

This project does not have any GUI or front-end. So, take your terminal to run this project!

## HOW TO RUN

Copy sources & install required libraries:

```
git clone git@github.com:crosspath/crystal-microservice-example.git
cd crystal-microservice-example
shards install
```

Configurate: copy file `.env.template` to `.env` & replace params `LUCKY_ENV`, `DATABASE_URL` & `API_KEY`

Create database:

```
lucky db.create
```

Initialise database for this microservice:

```
lucky db.migrate
lucky db.seed.sample_data
```

Run server:

```
lucky dev
```

Make a HTTP request with this template (assuming you ran this project on `localhost:5000`):

```
curl -X POST http://localhost:5000/api/v1/referrals \
     -d "api_key=<your-API_KEY-here>" \
     -d "order=<UserOrder.id>" \
     -d "referrer=<User.id>"
```

If your `API_KEY` is not valid, you'll get message:

    {"status":100,"error":"Not Authorised"}

If you try to add bonuses to the user, who does not exist in the database, then you'll get message:

    {"status":110,"error":"User Not Found"}

When user order is not found, you'll get this message:

    {"status":111,"error":"UserOrder Not Found"}

Selected `order` should not belong to selected `referrer`. Otherwise you'll get this message:

    {"status":112,"error":"User Cannot Invite Himself"}

If selected user order is referenced with another user already, then you'll get this:

    {"status":113,"error":"This UserOrder Is Already Referenced For Bonuses"}

And if everything correct, then you'll get this message (value of `bonuses` may be different, depending on the price of user order):

    {"status":200,"bonuses":0.28}
