task :build_config do
  File.open('./nginx/passenger.conf', 'w') do |file| 
    file.puts <<-PASSENGER_CONFIG
passenger_root           #{`passenger-config about root`.chomp};
passenger_ruby           #{`passenger-config about ruby-command`.match(/passenger_ruby (\S+)/)[1].chomp};
passenger_pool_idle_time 0;
passenger_max_pool_size  4;
PASSENGER_CONFIG
  end
  
  File.open('./nginx/proxy.conf', 'w') do |file|
    file.puts <<-PROXY_CONF
proxy_cache_path #{Dir.pwd}/tmp/data/ keys_zone=one:10m loader_threshold=300 loader_files=200;
PROXY_CONF
  end
  
  File.open('./nginx/logging.conf', 'w') do |file|
    file.puts <<-LOGGING_CONF
error_log   #{Dir.pwd}/log/nginx/error.log;
access_log  #{Dir.pwd}/log/nginx/access.log;
LOGGING_CONF
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