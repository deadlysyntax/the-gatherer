require "./outrider/version"
require "./outrider/engine"
require "./outrider/commandify"
require "./outrider/tools"
require "./outrider/project"


# Provides an interface to what commands can be run
module Outrider
  

  # When initialized, do so with our base project facade,
  # and change it later once everything else is initialized based on the specified project
  @project = Project.new
  
  
  db_config = YAML::load( File.open( "./outrider/database.yml" ) )
  ActiveRecord::Base.establish_connection(db_config)


  def self.set_project_object project
    require "./projects/#{project}/auxiliary"
    # Initialze object for the project we're working on
    @project = project.capitalize.constantize.new

  end

  

  
  
  def self.command_list
    %w(crawl_site)
  end


  
  def self.send command, options
      if @project.respond_to?(command) && command_list.include?(command.to_s)
        @project.send( command, options ) 
      else
        puts "Method doesn't exist"
      end
  end

  
end
