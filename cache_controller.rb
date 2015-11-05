require "rubygems"
require "tilt/erb"
require "bundler/setup"
Bundler.require(:default)
require 'sinatra/base'
require "sinatra/reloader"

class CacheController < Sinatra::Base
  
  set :protection, :except => :frame_options
  enable :logging
  register Sinatra::Reloader

  get '/' do
    "Hello"
  end
  
  not_found do
    "Can't find this page"
  end
end