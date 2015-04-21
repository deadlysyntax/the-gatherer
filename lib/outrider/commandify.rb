module Commandify

  
  def self.process
    sub_commands = %w(create_project create_project_db_row delete_project, crawl)
    global_opts  = Trollop::options do
      banner "CLI for Outrider data processing tools"
      opt :dry_run, "Don't actually do anything", :short => "-n"
      stop_on sub_commands
    end

    command      = ARGV.shift
    # Do not modify this
    command_opts = Trollop::options do
        opt :domain,     "The domain",                            :short   => "-d",  :type    => String, :default => ''
        opt :limit,      "Limit",                                 :short   => "-l",  :type    => Integer,:default => 1000
        opt :project,    "The name of the project",               :short   => "-p",  :type    => String, :default => ''
        opt :filename,   "Write data to a filename",              :short   => "-f",  :type    => String, :default => ''
        opt :restrict,   "Can only be crawled within the domain", :short   => "-r",  :default => true#,
        #opt :title,     "The title",                             :short   => "-t",  :type    => :default => ''
        opt :set_project,"If we need to set project",             :short   => "-s",:default => true
      end
      
      # Place custom command options here. See instructions at http://manageiq.github.io/trollop/
      command 


    return {
      :action  => command,
      :options => command_opts
    }
  end
  
  
  
end