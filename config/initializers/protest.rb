# Application wide configuration information & constants
#
# Derived from
# <http://www.viget.com/extend/simple-rails-or-ruby-application-configuration/>.
# call like this:
#
#    x = Protest::Foo
#    y = Protest::Config.name

### IMPORTS

require "ostruct"


### CONSTANTS & DEFINES

module Protest

   FOO = "bar"
   
   Config = OpenStruct.new({
			:site_title => "ProTest",
			:site_subtitle => "Proficiency testing for XYZ",
			:hosted_by_text => "Health Protection Agency",
			:hosted_by_url => "www.hpa.org.uk",
			:contact_email => "pma@agapow.net"
   })

end


### END
