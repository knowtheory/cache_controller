task :build_config do
  config = <<-CONFIG
passenger_root           #{`passenger-config about root`.chomp};
passenger_ruby           #{`passenger-config about ruby-command`.match(/passenger_ruby (\S+)/)[1].chomp};
passenger_pool_idle_time 0;
passenger_max_pool_size  4;
CONFIG

  File.open('./nginx/passenger.conf', 'w'){ |file| file.puts config }
end