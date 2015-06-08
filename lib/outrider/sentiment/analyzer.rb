#####################################################################
# Function analyzes the sentiment of a tweet. Very basic. This just
# imports a list of words with sentiment scores from file and uses
# these to perform the analysis.
#
# tweet: string -- string to analyze the sentiment of
# return: int -- 0 negative, 1 means neutral, and 2 means positive
#####################################################################

module Sentiment 
  
  module Analyze 
    

    def self.word( word, sentiment_hash )
      sentiment_hash[word] 
    end
    
    
    def self.document( text )
      # load the word file (words -> sentiment score)
      sentiment_hash = Sentiment::Helpers::load_sentiment_hash('words.txt')
      # tokenize the text into single words
      tokens         = text.split
      # Check the sentiment value of each token against the sentihash.
      # Since each word has a positive or negative numeric sentiment value
      # we can just sum the values of all the sentimental words. If it is
      # positive then we say the tweet is positive. If it is negative we 
      # say the tweet is negative.
      sentiment_total = 0.0
      for token in tokens do
        sentiment_value = Sentiment::Analyze::word(token, sentiment_hash)
        if sentiment_value
          # for debugging purposes
          #puts "#{token} => #{sentiment_value}"
          sentiment_total += sentiment_value
        end
      end
      return sentiment_total
    end 
    
    
    
    
    def self.positivity( sentiment_total, threshold = 0.0 )
      # if less then the negative threshold classify negative
      if sentiment_total < (-1 * threshold)
        return -1
      # if greater then the positive threshold classify positive
      elsif sentiment_total > threshold
        return 1
      # otherwise classify as neutral
      else
        return 0
      end
    end
    
    
    
      
  end
  
  
  
  
  module Helpers
    
    def self.load_sentiment_hash(filename)
      sentihash = {}
      # load the word file
      file      = File.open(File.join(File.dirname(__FILE__), filename), 'r')
      while( line = file.gets )
        parsedline      = line.chomp.split("\t")
        sentiscore      = parsedline[0]
        text            = parsedline[1]
        sentihash[text] = sentiscore.to_f
      end
      file.close
      return sentihash
    end
    
    
  end
  
  
  
end










#############################################################################
# Filename: basic-sentiment.rb
# Copyright: Christopher MacLellan 2010
# Description: This code adds functions to the string class for calculating
#              the sentivalue of strings. It is not called directly by the
#              tweet-search-sentiment.rb program but is included for possible 
#              future use.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################


class String
  @@sentihash = {}

  #####################################################################
  # Function that returns the sentiment value for a given string.
  # This value is the sum of the sentiment values of each of the words.
  # Stop words are NOT removed.
  #
  # return:float -- sentiment value of the current string
  #####################################################################
  def get_sentiment
    sentiment_total = 0.0

    #tokenize the string
    tokens = self.split
    
    for token in tokens do
      sentiment_value = @@sentihash[token]
      
      if sentiment_value
        
        # for debugging purposes
        #puts "#{token} => #{sentiment_value}"
        
        sentiment_total += sentiment_value
      end
    end

    return sentiment_total

  end
  
  #####################################################################
  # load the specified sentiment file into a hash
  #
  # filename:string -- name of file to load
  # sentihash:hash -- hash to load data into
  # return:hash -- hash with data loaded
  #####################################################################
  def load_senti_file (filename)
    # load the word file
    file = File.new(filename)
    while (line = file.gets)
      parsedline = line.chomp.split("\t")
      sentiscore = parsedline[0]
      text = parsedline[1]
      @@sentihash[text] = sentiscore.to_f
    end
    file.close
  end
  
end