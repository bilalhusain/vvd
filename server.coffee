zmq = require 'zmq'
winston = require 'winston'

movie = require './movie'

MQ_CONNECTION_STRING = 'tcp://127.0.0.1:9000'

search = (keyword, cb) ->
	movie.search keyword, (data) ->
		obj = JSON.parse data
		response = ''
		for result in obj.movies
			response += "#{result.title}, id: #{result.id}\n"
		cb response

detail = (id, cb) ->
	movie.detail id, (data) ->
		cb JSON.stringify(JSON.parse(data), 0, '\t')

s = zmq.createSocket 'rep' # ZMQ_REP type
s.bind MQ_CONNECTION_STRING, (err) ->
	if err
		winston.error err
		return

	s.on 'message', (data) ->
		winston.info "received #{data}"
		obj = JSON.parse data
		if not obj.type
			winston.error 'type not specified in message'
			return
		switch obj.type
			when 'search' then search(obj.keyword, (m) -> s.send(m))
			when 'detail' then detail(obj.id, (m) -> s.send(m))
			else winston.error "unknown message type '#{obj.type}'"

	winston.info "mq started at #{MQ_CONNECTION_STRING}"
