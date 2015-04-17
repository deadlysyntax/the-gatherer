class Engine
  
  attr_accessor :commands

  def initialize
    @commands = Commandify::process
  end
  
  
  def run
    outrider = Outrider.new
    outrider.set_project_object( @commands[:options][:project] )
    outrider.operate( @commands[:action], @commands[:options] )
  end
  
  
  
  
end