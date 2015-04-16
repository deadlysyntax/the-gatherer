class Project
  
  

  def not_implemented
    puts "This facade hasn't been implimented by the project"
  end

  
  
  
  def crawl_site options
    # This is a facade
    not_implemented
  end
  
  

    
end



class Projects < ActiveRecord::Base
  self.table_name = 'projects'
  has_many :project_data
end

class ProjectData < ActiveRecord::Base
  self.table_name = 'raw_data'
  belongs_to :projects
  
  validates_uniqueness_of :url
  
end


