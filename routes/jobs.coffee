Job = require('../app/models').Job
assert = require 'assert'


exports.jobs =
	get: (req, res) ->
		Job.findOne 'name': req.params.job_name, (err, job) ->
			res.send {"job": job}

	run: (req, res) ->
		Job.findOne 'name': req.params.job_name, (err, job) ->
			res.send {"job": job}
			res.send {"success": true}
			job.set('busy', true)
			job.save (err) ->
				assert.ifError err

			unbusy = () ->
				job.set('busy', false)
				job.save (err) ->
					assert.ifError err

			setTimeout unbusy, 5000
