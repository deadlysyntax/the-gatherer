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


