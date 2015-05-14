require 'redditkit'

module Redditbot
    
  @client = RedditKit::Client.new 'outrider_bot', 'AutobotsTransform123'

  
  ############################
  # Public Interface
  ############################
  
  
  #
  def self.get_subscribes
    @client.subscribed_subreddits
  end
  
  
  #
  def self.get_links options 
    links = @client.links( options[:sub], { :category => options[:category], :limit => options[:limit] } )
    write_data( options[:project], options[:filename], links, 'links' ) unless options[:project] == ''
  end
  
  
  # Expects a link object or link id
  def self.get_link_comments link, limit = 100
    comments = @client.comments( link, :limit => limit )
  end

  
  #
  def self.get_comments_on_links options
    links = read_data( options[:project], options[:filename], 'links' ).results
    #p links
    links.each do |link|
      comments = get_link_comments( link )
      write_data( options[:project], link.attributes[:id], comments, 'comments' )
    end 
  end
  
  
  
  #
  def self.get_link_by_name options
    p options
    link = @client.link( options[:linkname] )
    write_data( options[:project], options[:filename], link, 'links' )
  end
  
  
  
end