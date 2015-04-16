#require_relative "outrider/version"
require_relative "outrider/engine"
require_relative "outrider/commandify"
require_relative "outrider/tools"
require_relative "outrider/project"


# Provides an interface as to what commands can be run
class Outrider
  
  attr_reader :command_list, :project
  
  # When initialized, do so with our base project facade,
  # and change it later once everything else is initialized based on the specified project
  def initialize
    @project      = Project.new
    

    # TODO clean this shit
     # Fuck this is ugly
     db_config = YAML::load( File.open( File.expand_path(File.join(File.dirname(__FILE__), "outrider/database.yml" ) ) ))
     ActiveRecord::Base.establish_connection(db_config)
     
  end
  




  def set_project_object project
    project_path = File.expand_path(File.join(File.dirname(__FILE__), "projects/#{project}/auxiliary.rb"))

    if File.exist? project_path
      require_relative "projects/#{project}/auxiliary"
      # Initialze object for the project we're working on
      @project = project.classify.constantize.new
    else
      return false
    end
  end




  
  def operate command, options = {}
      if @project.respond_to?(command)
        @project.send( command, options ) 
      else
        return "Method doesn't exist"
      end
  end

  
end
