zmq = require 'zmq'
optparse = require 'optparse'
request = require 'request'
winston = require 'winston'

MQ_CONNECTION_STRING = 'tcp://127.0.0.1:9000'

# connect the message queue
count = 0
s = zmq.createSocket 'req' # ZMQ_REQ socket type
s.connect MQ_CONNECTION_STRING

s.on 'message', (data) ->
	console.log data.toString()
	count--
	s.close() if count is 0

s.on 'error', (err) ->
	count--
	winston.error err

sendMessage = (type, argName, argValue) ->
	msg =
		type: type
	msg[argName] = argValue
	console.log msg
	count++
	s.send JSON.stringify msg

switches  = [
	['-h', '--help', 'help text for vvd']
	['-s', '--search MESSAGE', 'search for a movie']
	['-d', '--detail MESSAGE', 'detail for a movie id']
]

parser = new optparse.OptionParser switches
#parser.banner = 'Usage: coffee vvd [options]'

parser.on 'help', () ->
	winston.info 'should print help text instead'

parser.on 'search', (option, keyword) ->
	winston.info "need to search for #{keyword}"
	sendMessage 'search', 'keyword', keyword

parser.on 'detail', (option, id) ->
	winston.info "need to fetch details for movie id #{id}"
	sendMessage 'detail', 'id', id

parser.parse process.ARGV

winston.info '[READY]'
