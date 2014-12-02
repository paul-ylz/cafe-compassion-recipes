$:.unshift 'lib'

require 'rack/cache'
use Rack::Cache

require 'app'
run App

