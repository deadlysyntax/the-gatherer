#!/Users/jaap/.rvm/rubies/ruby-2.2.1/bin/ruby

# Outrider loads in everything we need
require_relative './outrider.rb'
# The engine is initialized - this sets everything up for us
engine   = Engine.new
# The process of interprating commands is started
engine.run