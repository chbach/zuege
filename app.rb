require 'sinatra'
require "sinatra/reloader"
require 'slim'
require './lib/schedule_parser'
require './helpers/application_helpers'


# configuration
configure :development do
	register Sinatra::Reloader
end

helpers ApplicationHelpers

set :views, File.expand_path('../views', __FILE__)
set :public_folder, 'public'

# routes
get '/' do	
	slim :index
end

get '/data' do 
	content_type :json
	sp = ScheduleParser.new

	sp.parse!.to_json
end

