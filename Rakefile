require 'tilt/erb'

@here = File.dirname(__FILE__)
def render_conf(file, data_binding)
  template = File.read(File.join(@here, 'nginx', "#{file}.conf.erb"))
  ERB.new(template).result data_binding
end

task :build_config do
  File.open('./nginx/passenger.conf', 'w') do |file|
    passenger_root = `passenger-config about root`.chomp
    passenger_ruby = `passenger-config about ruby-command`.match(/passenger_ruby (\S+)/)[1].chomp
    file.puts render_conf('passenger', binding)
  end
  
  File.open('./nginx/proxy.conf', 'w') do |file|
    here = @here
    certificate_path     = ""
    certificate_key_path = ""
    file.puts render_conf('proxy', binding)
  end
  
  File.open('./nginx/logging.conf', 'w') do |file|
    here = @here
    file.puts render_conf('logging', binding)
  end

  File.open('./nginx/cache_controller.conf', 'w') do |file|
    here = @here
    file.puts render_conf('cache_controller', binding)
  end
  
  File.open('./nginx/pid.conf', 'w') do |file|
    here = @here
    file.puts render_conf('pid', binding)
  end
  
end

task :start do
  puts <<-MESSAGE
In order to acquire port 80 you must enter your administrator password.
If you are uncomfortable with entering your administrator password,
feel free to read and review the Rakefile to make sure this code
doesn't do anything nefarious.
MESSAGE
  `sudo nginx -c #{Dir.pwd}/nginx/nginx.conf`
end

task :stop do
  `sudo nginx -c #{Dir.pwd}/nginx/nginx.conf -s stop`
end

task :reload do
  `sudo nginx -c #{Dir.pwd}/nginx/nginx.conf -s reload`
end