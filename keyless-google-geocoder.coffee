enc = require 'urlencode'

serialize = (address)->
	query = enc(address)
	url = "https://www.google.com/search?tbm=map&fp=1&authuser=1&hl=en&gl=us&q=#{query}&tch=0&ech=0&psi=xa9mWuOLDIfSsAW3xoGQBA.1516679110320.1" #copied straight from chrome inspector
	method: 'get'
	url: url
	gzip: true
	encoding: 'utf8'
	headers:
		'x-chrome-uma-enabled': 0 #do not report anything to google, the google AI will analyze you if this is set to 1. 
		'x-client-data': 'CIe2yQEIo7bJAQjBtskBCPqcygEIqZ3KAQioo8oB' #not sure what this is, but i copied it anyway
		'referer': 'https://www.google.com/' #pretend we are google
		#google AI monitors all requests that dont match a typical user profile and will block you if you dont pretend to be a human, so make sure your agent is always spoofed!
		'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36'


parse = (body)->
	addr = lat = lon = addr1 = addr2 = null
	try
		[lat,lon] = body.match(/null,((?:\-|\+)?\d?\d?\d\.\d+\,(?:\-|\+)?\d\d?\d?.\d+)]/)[1].split(',')
		lat = Number(lat)
		lon = Number(lon)
	catch e
		console.error 'could not parse lat/lon: '+address
	try
		match = body.match(/,\\"([A-Za-z\u00C0-\u00FF\u2000-\u206F\u2E00-\u2E7F#\-,. \d]+ [A-Za-z\u00C0-\u00FF\u2000-\u206F\u2E00-\u2E7F#,. \-\d]+)\\"/g)
		[addr1,addr2] = match
		if !addr2 || (addr1 && addr1.length > addr2.length)
			addr = addr1
		else
			addr = addr2
		addr = addr.match(/([A-Za-z\u00C0-\u00FF\u2000-\u206F\u2E00-\u2E7F#\-,. \d]+)/g)[1]
	catch e
		console.error 'could not parse address: '+address
	
	return {addr,lat,lon}


module.exports.parse = parse
module.exports.serialize = serialize