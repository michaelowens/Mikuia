class exports.Leaderboard extends Mikuia.Model
	constructor: (@name) ->
		@model = 'leaderboard'

		Mikuia.Element.register 'leaderboards', @name

	getName: -> @name

	# Info :o

	getInfo: (field, callback) ->
		await @_hget '', field, defer err, data
		callback err, data

	setInfo: (field, value, callback) ->
		await @_hset '', field, value, defer err, data
		callback err, data

	# Display

	getDisplayName: (callback) ->
		await @getInfo 'display_name', defer err, data
		callback err, data

	setDisplayName: (display, callback) ->
		await @setInfo 'display_name', display, defer err, data
		if callback
			callback err, data

	getDisplayHtml: (callback) ->
		await @getInfo 'display_html', defer err, data
		if err || !data
			data = '<%value%>'
		callback err, data

	setDisplayHtml: (display, callback) ->
		await @setInfo 'display_html', display, defer err, data
		if callback
			callback err, data

	# Ordering

	getReverseOrder: (callback) ->
		await @getInfo 'reverseOrder', defer err, data
		if data == 'true'
			data = true
		if data == 'false'
			data = false
		callback err, data

	setReverseOrder: (order, callback) ->
		await @setInfo 'reverseOrder', order, defer err, data
		if callback
			callback err, data

	# Scores

	getScore: (channel, callback) ->
		await @_zscore 'scores', channel, defer err, data
		callback err, data

	setScore: (channel, score, callback) ->
		await @_zadd 'scores', score, channel, defer err, data
		if callback
			callback err, data