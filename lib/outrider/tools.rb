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
require 'time'
require 'trollop'


module OutriderTools
  
  
  module Crawl 
    

    
    
    def self.site project, operate
      
      @log = Logger.new(STDOUT)
      
      recurse = ->() do
        #
        # Pick a from the database to crawl
        unless ProjectData.where( status: 'unscraped', project_id: project[:id] ).exists?
          @log.info "No pages to scrape"
          return
        end  

        working_page = ProjectData.where( status: 'unscraped', project_id: project[:id]).first
        working_page.status = 'processing'
        working_page.save
        
        @log.info "Scraping #{working_page.url}"
        #
        #   Scape it
        data, links = OutriderTools::Scrape::page( working_page.url, operate)

        unless links.nil? 
          links.each  do |link|
            # Check if link already exists
            #if ProjectData.find_by(url: link.to_s).nil?
            unless ProjectData.where( url: link.to_s, project_id: project[:id] ).exists?  
              ProjectData.create({
                :url        => link.to_s,
                :status     => 'unscraped',
                :project_id => project[:id]
              })
              @log.info "Adding new url to database: #{link.to_s}"
            else
              @log.info "URL already exists in database: #{link.to_s}"
            end
          end
        end

        @log.info "Saving page data for url #{working_page.url}"
        @log.info data[:status]
        working_page.update( data ) unless data.nil?

        recurse.call
      end

      recurse.call
      
    end

    
    
    
  end
  
  module Scrape
     
     
     
     
     
     def self.page( url, operate )
       @log      = Logger.new('log/logfile.log', 'daily')
       files     = OutriderTools::Clean::file_types
       begin
         page_uri = URI.parse( url )
         doc      = Nokogiri.HTML( open(page_uri) ) 
         # Yield page and URI to the block passed in 
         data  = operate.( doc, page_uri )        

         # Find all the links on the page
         hrefs = doc.css('a[href]').map{ |a| a['href'] }

         clean_uris  = OutriderTools::Clean::tidy_urls( hrefs, page_uri, page_uri, files )
         return data, clean_uris
         
       rescue OpenURI::HTTPError # Guard against 404s
         @log.error "Skipping invalid link #{page_uri}"
       rescue ArgumentError => e
         @log.error "Skipping page that causes argument error: #{e}"
       rescue RuntimeError => e
         @log.error "Invalid Redirection: #{e}"
       rescue Exception => e
         @log.error "Error #{e}"
         raise e
       end
       
       return { :status => 'rejected' }
       
     end
     
  end
  
  
  
  
  module Clean
    
    
    def self.tidy_urls hrefs, page_uri, domain, files 
      
      # Make these URIs, throwing out problem ones like mailto:
      uris = hrefs.map{ |href| URI.join( page_uri, href ) rescue nil }.compact

      # Pare it down to only those pages that are on the same site
      uris.select!{ |uri| uri.host == domain.host }

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
    
    def self.get_filepath base, filename
      File.expand_path(File.join(File.dirname(base), filename ))
    end
    
  end
  
  
  
  
  
  
  
end




