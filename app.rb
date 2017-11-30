require 'sinatra'
require 'sinatra/reloader' if development?

# require_relative 'lib/mastermind'

get '/' do
  "Hello world!"
end

