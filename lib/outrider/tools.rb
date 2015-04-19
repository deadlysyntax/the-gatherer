require 'nokogiri'
require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/inflector'
require 'open-uri'
require 'uri'
require 'set'
require 'json'
require 'yaml'
require 'logger'


module OutriderTools
  
  
  module Crawl 
    

    def self.crawl_site( starting_at, limit = -1, &each_page )
      # 
      files = OutriderTools::Clean::file_types
      # 
      starting_uri  = URI.parse( starting_at )    #
      seen_pages    = Set.new                     # Keep track of what we've seen
      counter       = 0
      @log          = Logger.new('logfile.log', 'daily')
      

      crawl_page = ->(page_uri) do              # A re-usable mini-function
        
        unless seen_pages.include?(page_uri) && ( limit == -1 || counter >= limit )
          seen_pages << page_uri.to_s       # Record that we've seen this
          begin
            
            counter+=1
            
            # Get the page
            doc = Nokogiri.HTML( open(page_uri) ) 
            
            # Yield page and URI to the block passed in 
            each_page.call( doc, page_uri)        

            # Find all the links on the page
            hrefs = doc.css('a[href]').map{ |a| a['href'] }

            uris  = OutriderTools::Clean::tidy_urls( hrefs, page_uri, starting_uri, files )

            # Recursively crawl the child URIs
            uris.each{ |uri| crawl_page.call(uri) }
            

          rescue OpenURI::HTTPError # Guard against 404s
            warn "Skipping invalid link #{page_uri}"
          rescue ArgumentError => e
            warn "Skipping page that causes open-uri argument error"
          rescue RuntimeError => e
            warn "Invalid Redirection"
          rescue Exception => e
            @log.info "Error #{e}"
            raise e
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
      
      # Throw out duplicates
      uris.reject!{ |uri| ProjectData.exists?( url: uri.to_s) }

      # Remove #foo fragments so that sub-page links aren't differentiated
      uris.each{ |uri| uri.fragment = nil }
      
      return uris
      
    end
    
    
    
    
    
    
    
    def self.file_types sub = 'all' 
      
      case sub
      when "all" 
        return %w[png jpeg jpg gif svg txt js css zip gz pdf]
      when "images"
        return %w[png jpeg jpg gif svg]
      when "pdfs"
        return %w[pdf]
      else
        return %w[png jpeg jpg gif svg txt js css zip gz pdf]
      end
      
    end
    
     
  end
  
  
  
  
  module Store
    
    
    #def self.write_data project, filename, data, format
      
      # TODO change this to a different folder
     # dirname = File.dirname(__FILE__) + "/data/#{project}"

     # unless File.directory?(dirname)
     #   FileUtils.mkdir_p(dirname)
     # end

    #  File.open( dirname + '/' + filename + '.data', 'w+') { |file| 
    #    file.write( YAML::dump(data) ) 
    #  }
    #end



    #def self.read_data project, filename, format
     #  YAML::load( File.read( File.dirname(__FILE__) + "/data/#{project}/#{filename}") )
    #end
    
    
    def self.get_filepath base, filename
      File.expand_path(File.join(File.dirname(base), filename ))
    end
    
  end
  
  
  
  
  
  
  
end




