http = require 'http'

# api key for rotten tomatoes
key = 'dead'

search = module.exports.search = (q, callback) ->
	client = http.createClient 80, 'api.rottentomatoes.com'
	req = client.request 'GET', '/api/public/v1.0/movies.json?q=' + q + '&apikey=' + key, {
		Host: 'api.rottentomatoes.com',
		Connection: 'Close'
	}
	req.end()

	data = ''
	req.on 'response', (res) ->
		res.on 'data', (chunk) ->
			data += chunk.toString()	
		res.on 'end', () ->
			callback data.trim()

detail = module.exports.detail = (movieId, callback) ->
	client = http.createClient 80, 'api.rottentomatoes.com'
	req = client.request 'GET', '/api/public/v1.0/movies/' + movieId + '.json?apikey=' + key, {
		Host: 'api.rottentomatoes.com',
		Connection: 'Close'
	}
	req.end()

	data = ''
	req.on 'response', (res) ->
		res.on 'data', (chunk) ->
			data += chunk.toString()
		res.on 'end', () ->
			callback data.trim()

