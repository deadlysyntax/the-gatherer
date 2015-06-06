
module helpers
  
  def load_view view
    require_relative "../views/#{view}.rb"
  end
  
end