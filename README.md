vvd
===

The final target is not a webapp, instead a cli is targeted which can be used from multiple networks.

Basically it is the underlying api mock. Usage of the command line interface:

    vvd search summer

    vvd detail 34

Design
---

Uses rotten tomatoes api internally (movie.coffee). Posts every action to the zmq which in turn make the request.

Why mq?
---

Message Queue provides an additional layer where requests and messages can be intercepted and filtered.

Also, it decouples the internals; especially, the configuration and the keys from the developer.

I have no clue what I am talking about! I just wanted to do this, badly!!

Example request:
{
	  "type": "search"
	, "keyword": "blarg"
}

{
	  "type": "detail"
	, "id": "f00"
}

