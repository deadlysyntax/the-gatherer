require 'trollop'

module Commandify

  
  def self.process
    sub_commands = %w(crawl_site create_project create_project_db_row delete_project)
    global_opts  = Trollop::options do
      banner "CLI for Outrider data processing tools"
      opt :dry_run, "Don't actually do anything", :short => "-n"
      stop_on sub_commands
    end

    command      = ARGV.shift
    command_opts = Trollop::options do
        opt :domain,   "The domain",                            :short   => "-d",  :type    => String, :default => ''
        opt :limit,    "Limit",                                 :short   => "-l",  :type    => Integer,:default => 1000
        opt :project,  "The name of the project",               :short   => "-p",  :type    => String, :default => ''
        opt :filename, "Write data to a filename",              :short   => "-f",  :type    => String, :default => ''
        opt :restrict, "Can only be crawled within the domain", :short   => "-r",  :default => true#,
        #opt :title,    "The title",                             :short   => "-t",  :type    => :default => ''
      end

    
    
    return {
      :action  => command,
      :options => command_opts
    }
  end
  
  
  
end