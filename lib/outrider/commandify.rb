require 'trollop'

module Commandify

  
  def self.process
    sub_commands = %w(crawl_site)
    global_opts  = Trollop::options do
      banner "CLI for Outrider data processing tools"
      opt :dry_run, "Don't actually do anything", :short => "-n"
      stop_on sub_commands
    end

    command      = ARGV.shift
    command_opts = Trollop::options do
        opt :domain,  "A domain to crawl",                      :short   => "-d",  :type    => String, :default => ''
        opt :limit,    "Limit",                                 :short   => "-l",  :type    => Integer,:default => 1000
        opt :project,  "The name of the project",               :short   => "-p",  :type    => String, :default => ''
        opt :filename, "Write data to a filename",              :short   => "-f",  :type    => String, :default => ''
        opt :restrict, "Can only be crawled within the domain", :short   => "-r",  :default => true
      end

    
    
    return {
      :action  => command,
      :options => command_opts
    }
  end
  
  
  
end