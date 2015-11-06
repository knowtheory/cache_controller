require "rubygems"
require "tilt/erb"
require "bundler/setup"
Bundler.require(:default)
require 'sinatra/base'
require "sinatra/reloader"

class CacheController < Sinatra::Base
  
  configure do
    set :protection, :except => :frame_options

    enable :logging, :dump_errors
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    set :raise_errors, true
    register Sinatra::Reloader
  end

  get '/' do
    "Hello"
  end
  
  get '/404' do
    status 404
  end
  
  get '/500' do
    status 500
  end
  
  not_found do
    "Can't find this page"
  end
  
  error 500 do
    "This is a 500 error"
  end
end
