require "rubygems"
require "tilt/erb"
require "bundler/setup"
Bundler.require(:default)
require 'sinatra/base'
require "sinatra/reloader"

class CacheController < Sinatra::Base

  use Rack::ETag

  configure do
    set :protection, :except => :frame_options

    enable :inline_templates

    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    set :raise_errors, true
    register Sinatra::Reloader
  end

  get '/' do
    sleep 1
    #cache_control :public, :must_revalidate, :max_age => 60
    erb :index, :locals => { :message => "Hello" }
  end
  
  get '/data.json' do
    content_type :json
    #cache_control :public, :must_revalidate, :max_age => 10
    #cache_control :nocache
    sleep 1
    now = Time.now
    data = { 
      :color => ((now.sec/10) % 2 == 0 ? "red" : "blue"),
    }
    response = data.to_json
    response = "#{params["callback"]}(#{response})" if params["callback"]
    response
  end
  
  get '/set_cookie' do
    
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

__END__
@@ layout
<html>
<head><title>CacheController</title></head>
<body>
  <%= yield %>
</body>
</html>

@@ index
<h1><%= message %></h1>
