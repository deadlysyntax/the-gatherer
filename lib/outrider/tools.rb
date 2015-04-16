require 'nokogiri'
require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'
require 'open-uri'
require 'uri'
require 'set'
require 'json'
require 'yaml'


module OutriderTools
  
  
  module Crawl 
    
    def self.get_links_at_url url, domain
      
      data = Nokogiri::HTML(open(url))
      
      raw_links      = data.css('a')

      stripped_links = raw_links.map { |link| 
        
        link['href'] 
      }

      return stripped_links
    end
    
    
    
    
    
    def self.crawl_site( starting_at, &each_page )
      # 
      files = OutriderTools::Clean::file_types
      # 
      starting_uri  = URI.parse( starting_at )    #
      seen_pages    = Set.new                     # Keep track of what we've seen



      crawl_page = ->(page_uri) do              # A re-usable mini-function
        unless seen_pages.include?(page_uri)
          seen_pages << page_uri                # Record that we've seen this
          begin
            # Get the page
            doc = Nokogiri.HTML( open(page_uri, :http_basic_authentication => ['', ''])) 
            
            # Yield page and URI to the block passed in 
            each_page.call(doc,page_uri)        

            # Find all the links on the page
            hrefs = doc.css('a[href]').map{ |a| a['href'] }

            uris  = OutriderTools::Clean::tidy_urls( hrefs, page_uri, starting_uri, files )

            # Recursively crawl the child URIs
            uris.each{ |uri| crawl_page.call(uri) }

          rescue OpenURI::HTTPError # Guard against 404s
            warn "Skipping invalid link #{page_uri}"
          end
          
        end
      end
      crawl_page.call( starting_uri )   # Kick it all off!
    end
    
    
    
  end
  
  
  
  module Scrape
     
  end
  
  
  
  
  module Clean
    
    
    
    
    def self.tidy_urls hrefs, page_uri, starting_uri, files 
      
      # Make these URIs, throwing out problem ones like mailto:
      uris = hrefs.map{ |href| URI.join( page_uri, href ) rescue nil }.compact

      # Pare it down to only those pages that are on the same site
      uris.select!{ |uri| uri.host == starting_uri.host }

      # Throw out links to files (this could be more efficient with regex)
      uris.reject!{ |uri| files.any?{ |ext| uri.path.end_with?(".#{ext}") } }
      
      # Throw out links to files (this could be more efficient with regex)
      uris.reject!{ |uri| ProjectData.exists?( url: uri.to_s) }

      # Remove #foo fragments so that sub-page links aren't differentiated
      uris.each{ |uri| uri.fragment = nil }
      
      return uris
      
    end
    
    
    
    
    def self.file_types sub = 'all' 
      
      case sub
      when "all" 
        return %w[png jpeg jpg gif svg txt js css zip gz]
      else
        return %w[png jpeg jpg gif svg txt js css zip gz]
      end
      
    end
    
     
  end
  
  
  
  
  module Store
    
    
    def self.write_data project, filename, data, format
      
      # TODO change this to a different folder
      dirname = File.dirname(__FILE__) + "/data/#{project}"

      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      File.open( dirname + '/' + filename + '.data', 'w+') { |file| 
        file.write( YAML::dump(data) ) 
      }
    end



    def self.read_data project, filename, format
       YAML::load( File.read( File.dirname(__FILE__) + "/data/#{project}/#{filename}") )
    end
    
    
  end
  
  
  
  
  
  
  
end




