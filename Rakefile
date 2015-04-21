require "bundler/gem_tasks"
require "rspec/core/rake_task" 
require "net/ssh"
require "yaml"

task :default => :spec




namespace :project  do
  desc "Builds new project on development machine and production"
  task :build, [:title, :domain] do |t, args|
    
    @host = YAML.load_file('config/hosts.yml')['production']
    puts "building project #{args}"
    
    # add project to local system
    #sh "./lib/ignite.rb create_project -p #{args[:title]} -d #{args[:domain]}"

    # ssh and run on production server
    begin
      ssh = Net::SSH.start(@host['host'], @host['user'], :port => @host['port'], :password => @host['password'] )
      #res = ssh.exec!("/var/www/outrider/current/lib/ignite.rb create_project -p #{args[:title]} -d #{args[:domain]}")
      res = ssh.exec!("source $HOME/.rvm/scripts/rvm; /var/www/outrider/current/lib/ignite.rb create_project -p #{args[:title]} -d #{args[:domain]}")
      ssh.close
      puts res
    rescue Exception => e
      puts "Unable to connect to #{@host['host']} using #{@host['user']} :: #{e}"
    end
  end
end