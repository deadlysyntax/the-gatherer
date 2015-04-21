module Commandify

  
  def self.process
    # Do not modify this line
    sub_commands = %w(create_project create_project_db_row delete_project, crawl)
    
    
    
    # Place custom command options here. See instructions at http://manageiq.github.io/trollop/
    sub_commands << %w()
    
    
    
    
    global_opts  = Trollop::options do
      banner "CLI for Outrider data processing tools"
      opt :dry_run, "Don't actually do anything", :short => "-n"
      stop_on sub_commands
    end

    command      = ARGV.shift
    # Do not modify this
    command_opts = Trollop::options do
       # REQUIRED. Do not mess with these. Do not duplicate arguments or their short form. Run tests after modifying
        opt :domain,     "The domain",                            :short   => "-d",  :type    => String, :default => ''
        opt :limit,      "Limit",                                 :short   => "-l",  :type    => Integer,:default => 1000
        opt :project,    "The name of the project",               :short   => "-p",  :type    => String, :default => ''
        opt :filename,   "Write data to a filename",              :short   => "-f",  :type    => String, :default => ''
        opt :restrict,   "Can only be crawled within the domain", :short   => "-r",  :default => true
        opt :set_project,"If we need to set project",             :short   => "-s",:default => true
        
        # CUSTOM. Place custom command options here
        
        
      end


    return {
      :action  => command,
      :options => command_opts
    }
  end
  
  
  
end