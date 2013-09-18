mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/cibyl'

repo_schema = mongoose.Schema { 
	name: String
}

job_schema = mongoose.Schema { 
	name: String
	label: String
	description: String
}


exports.Repo = mongoose.model 'Repo', repo_schema
exports.Job = mongoose.model 'Job', job_schema
