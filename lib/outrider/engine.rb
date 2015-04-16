class Engine
  
  attr_reader :commands, :messages

  def initialize
    @commands = Commandify::process
  end
  
  
  def run
    outrider = Outrider.new
    outrider.set_project_object( @commands[:options][:project] )
    outrider.operate( @commands[:action], @commands[:options] )
  end
  
  
  
  
end