Repo = require('../app/models').Repo
assert = require 'assert'

exports.repos =
	get: (req, res) ->
		Repo.find (err, repos) ->
			res.send {"repos": repos}
