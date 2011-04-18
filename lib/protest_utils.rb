# Utility functions for use throughout the application.


### IMPORTS

require 'pp'


### CONSTANTS & DEFINES


### IMPLEMENTATION ###

module ProtestUtils
	public
	
	# Convert some (any) string to a form suitable for ue as an ID
	#
	# Currently this lowers case, cleans up whitespace and replaces punctuation
	#
	def self.str_to_id (s)
		return s.downcase.gsub(/\W/, ' ').strip.gsub(/\s+/, '_')
	end

end


### END ###
