express = require 'express'
# Persistence = require './lib/persistence'
http = require 'http'
urlencode = require 'urlencode'
assert = require 'assert'
require 'js-yaml'

config = false  # static data-model that is loaded
persistence = false # persistence class wrapper for mongo in this case

config_path =  __dirname + '/content/config.yml'
console.log "Reading config from: #{config_path}"
job_map = {}
config = require config_path
for job in config.jobs
  job_map[job.name] = job

console.log config

db_connect = (cb=()->) ->
  persistence = new Persistence config.mongo.host, config.mongo.port, config.mongo.db
  cb()

setup_server = () ->

  app = express()

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

  app.get '/api/config', (req, res) ->
    console.log "-- Config"
    res.send {"config": config}


  app.get '/api/job/:job_name', (req, res) ->
    job_name = req.params.job_name
    console.log "-- Meta"
    console.log job_name
    console.log req.body
    console.log "Meta of #{job_name}"
    if job_name of job_map
      job = job_map[job_name]
    console.log job
    res.send {"job": job}

  app.post '/api/job/:job_name/run', (req, res) ->
    console.log "-- Run"
    job_name = req.params.job_name
    console.log job_name
    console.log req.body
    console.log "Running #{job_name}"
    if req.body.name of job_map
      job = job_map[job_name]
    console.log job
    console.log "- Steps:"
    for step in job.steps
      console.log step
    job_map[job_name].busy = true
    res.send {"success": true}

    unbusy = () ->
      job_map[job_name].busy = false

    setTimeout unbusy, 5000

  app.listen 8080
  console.log "Listening on port 8080"

db_connect setup_server
