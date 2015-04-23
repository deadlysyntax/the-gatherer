#require_relative "outrider/version"
require_relative "./engine"
require_relative "./tools"
require_relative "./commandify"
require_relative "./project"


# Provides an interface as to what commands can be run
class Outrider
  
  
  attr_reader :command_list, :project, :db, :config
  
  
  
  # When initialized, do so with our base project facade,
  # and change it later once everything else is initialized based on the specified project
  def initialize
    @project           = Project.new
    @config = {
      :database => load_yaml( __FILE__, "../../config/db.yml",   "Couldn't load database config file"),
      :messages => load_yaml( __FILE__, "../../config/msg.yml",  "Couldn't load messages config file")
    }
    @db                = load_database 
  end
  
  



  def set_project_object project
    project_path = OutriderTools::Store::get_filepath __FILE__, "../projects/#{project}/auxiliary.rb"
    if File.exist? project_path
      require_relative "../projects/#{project}/auxiliary"
      # Initialze object for the project we're working on
      @project = project.classify.constantize.new
    else
      return false
    end
  end




  
  def operate command, options = {}
    
      return @config[:messages]["no_method"] if command.nil?
      
      if @project.respond_to?(command)
        return @project.send( command, options ) 
      else
        return @config[:messages]["no_method"]
      end
  end




  private




  def load_yaml file_object, filename, error_message
    file = OutriderTools::Store::get_filepath file_object,  filename 
    if File.exist? file
       return YAML::load( File.open( file ))
    else
       return error_message
    end
  end




  def load_database
       ActiveRecord::Base.establish_connection(@config[:database])
  end
  
  
end
