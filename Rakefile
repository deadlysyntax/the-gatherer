require "bundler/gem_tasks"
require "rspec/core/rake_task" 
require "net/ssh"
require "yaml"

task :default => :spec



class TaskHelper
  
  attr_reader :data
  
  def initialize env
    #load environment variables
    @data  = YAML.load_file('config/hosts.yml')[env]
  end
  

end





namespace :project  do
  
  @prod   = TaskHelper.new('prod').data
  @dev    = TaskHelper.new('dev').data
  
  
  desc "Builds new project on development machine and production"
  task :build, [:title, :domain] do |t, args|
    puts ":: Building project #{args}"
    
    command = "#{@prod['ruby']} #{@prod['ignite_path']} create_project_db_row -p #{args[:title]} -d #{args[:domain]}"
    # add project to local system
    sh "#{@dev['ignite_path']} create_project -p #{args[:title]} -d #{args[:domain]}"
    # ssh and run on production server
    begin
      ssh = Net::SSH.start(@prod['host'], @prod['user'], :port => @prod['port'], :password => @prod['password'] )
      res = ssh.exec!(command)
      ssh.close
      puts res
    rescue Exception => e
      puts "Unable to connect to #{@prod['host']} using #{@prod['user']} :: #{e}"
    end
  end
  
  
  
  
end