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
		:site_subtitle => "Proficiency testing for FMDV",
		:hosted_by_text => "IAH",
		:hosted_by_url => "iah.ac.uk",
		:contact_email => "yanmin.li@bbsrc.ac.uk"
   })

end


### END
