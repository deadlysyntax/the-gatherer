class Project
  
  attr_reader :config
  
  
  
  def initialize
    @config = {}
  end
  
  
  
  def set_config name
    project_meta = Projects.find_by( title: name )
    @config = {
      :id     => project_meta.id,
      :title  => project_meta.title,
      :domain => project_meta.domain
    }
  end
  
  
  
  
  def create options
    
    class_name   = options[:project].classify
    project_name = options[:project].parameterize.underscore
    file_path    = OutriderTools::Store::get_filepath __FILE__, "../projects/#{options[:project]}/auxiliary.rb"
    
    #create project in database
    project = Projects.create({ :title => options[:project], :domain => options[:domain] })
    puts "Project created in database: #{project.id}"
    
    #create project files by making a copy of test_project
    require 'fileutils'
    
    #create directories if they dont exist
    dirname = File.dirname(file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
      puts "Making directory: #{dirname}"
    end
    
    #generate our default project class
    File.open( file_path, 'w') { |file| 
      file.write(%Q{class #{class_name} < Project\n\tdef initialize\n\t\tproject_name :#{project_name}\n\tend\nend})
      puts "Auxiliary File Created in: #{file.path}"
    }
    
    
  end
  
  
  
  
  def delete options
    
    #delete folder
    folder_path  = OutriderTools::Store::get_filepath __FILE__, "../projects/#{options[:project]}"
    FileUtils.rm_rf( folder_path )
    puts "Deleting: #{folder_path}"
    
    #delete from database
    project = Projects.find_by( title: options[:project] )
    project.destroy
    puts "Deleting: project from database: #{options[:project]}"
    
  end
  
  
  
  #
  # These methods are here simply to help run our unit tests
  def test_super options
    return "Super Test Called"
  end
  def project_name name
    set_config name.to_s
  end
  
  

  def not_implemented
    puts "This facade hasn't been implimented by the project"
  end

  
  
  
  
  
  # These methods are our fallback for if 
  # the method doesn't exist in each project's auxiliary file (which all extend this class)
  # This is our public interface
  
  
  
  def crawl_site options
    # This is a facade
    not_implemented
  end
  
  
  
  # A command line tool that lets us build a project
  # /lib/ignite.rb create_project -p project -d domain.com
  #
  def create_project options
    return create options
  end  
    
    
    
   def delete_project options 
    return delete options
  end



    
end





# Access to active record classes
# This makes them usable throughout our code, as project.rb  
# is autoloaded


class Projects < ActiveRecord::Base
  self.table_name = 'projects'
  has_many :project_data
end



class ProjectData < ActiveRecord::Base
  self.table_name = 'raw_data'
  belongs_to :projects
  
  validates_uniqueness_of :url
  
end


