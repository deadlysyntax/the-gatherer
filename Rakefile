require "bundler/gem_tasks"
require "rspec/core/rake_task" 
require 'net/ssh'


task :default => :spec


desc "Deploys to linode"
task :deploy_to_linode do
  
  begin
    Net::SSH.start("50.116.15.244", "deadlysyntax", :password => "pz9o#eN$)fu~v-W)$(1uX}U13i:MdM$TPSE//['S", :port => "6668") do |session|

         session.open_channel do |channel|

           channel.request_pty do |ch, success| 
             raise "Error requesting pty" unless success 

             ch.send_channel_request("shell") do |ch, success| 
               raise "Error opening shell" unless success  
             end  
           end

           channel.on_data do |ch, data|
             STDOUT.print data
           end 

           channel.on_extended_data do |ch, type, data|
             STDOUT.print "Error: #{data}\n"
           end

           channel.send_data( "1\n" )

           session.loop
         end  
       end
  rescue Exception => e
    puts "Unable to connect:: #{e}"
  end
  
  
  
  
  #sh "ssh deadlysyntax@50.116.15.244 -p6668" do
  #  sh "cd /var/www/outrider"
  #  sh "git pull origin master"
    
  #end
  
  #{}"Passphrase: Sepultura8795373
  #{}"
  #bundle install
end
