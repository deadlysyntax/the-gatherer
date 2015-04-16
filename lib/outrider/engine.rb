class Engine
  
  attr_reader :commands

  def initialize
    @commands = Commandify::process
  end
  
  
  def run
    
    Outrider::set_project_object( @commands[:options][:project] )

    Outrider::send( @commands[:action], @commands[:options] )

  end
  
  
  
end