class exports.Streams
	constructor: (@Mikuia) ->

	get: (stream, callback) ->
		await Mikuia.Database.hgetall 'mikuia:stream:' + stream, defer err, stream
		callback err, stream

	getAll: (callback) ->
		await Mikuia.Database.smembers 'mikuia:streams', defer err, streams
		callback err, streams

	getAllSorted: (sortMethod, callback) ->
		sortLeaderboard = new Mikuia.Models.Leaderboard sortMethod
		sorting = []
		streams = {}
		await @getAll defer err, onlineStreams
		for stream in onlineStreams
			await
				@get stream, defer err, streamData
				sortLeaderboard.getScore stream, defer err2, score
			if !err
				streams[stream] = streamData
			if !err2 && score
				sorting.push [ stream, score ]

		await sortLeaderboard.getReverseOrder defer err, reverseOrder

		sorting.sort (a, b) ->
			if reverseOrder
				return a[1] - b[1]
			else
				return b[1] - a[1]

		callback sorting, streams