class Engine
  
  attr_accessor :commands

  def initialize
    @commands = Commandify::process
  end
  
  
  def run
    p "No Method Given" if @commands[:action].nil?
    outrider = Outrider.new
    outrider.set_project_object( @commands[:options][:project] ) if @commands[:options][:set_project] == true
    outrider.operate( @commands[:action], @commands[:options] )
  end
  
  
  
  
end