express = require 'express'
http = require 'http'
urlencode = require 'urlencode'
assert = require 'assert'
routes = require('./routes/index').routes
Job = require('./app/models').Job
Repo = require('./app/models').Repo

require 'js-yaml'

config = false  # static data-model that is loaded

config_path =  __dirname + '/content/config.yml'
console.log "Reading config from: #{config_path}"
job_map = {}
config = require config_path

load_config = (config) ->
  load_job = (job_config) ->
    console.log job_config
    Job.findOne 'name': job_config.name, (err, jobs) ->
      assert.ifError err
      console.log jobs
      if not jobs
        console.log "Adding"
        job = new Job(job_config);
        console.log job
        job.save (err) ->
          assert.ifError err
      else
        console.log "Not Adding"

  load_repo = (repo_config) ->
    console.log repo_config
    Repo.findOne 'name': repo_config.name, (err, repos) ->
      assert.ifError err
      console.log repos
      if not repos
        console.log "Adding"
        repo = new Repo(repo_config);
        console.log repo
        repo.save (err) ->
          assert.ifError err
      else
        console.log "Not Adding"

  for job_config in config.jobs
    load_job job_config

  for repo_config in config.repos
    load_repo repo_config

load_config config

setup_server = () ->

  app = express()

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

  app.get '/api/config', (req, res) ->
    console.log "-- Config"
    res.send {"config": config}

  console.log routes

  app.get  '/api/job/:job_name', routes.jobs.get
  app.post '/api/job/:job_name/run', routes.jobs.run
  app.get '/api/repos', routes.repos.get

  app.listen 8080
  console.log "Listening on port 8080"

setup_server()
