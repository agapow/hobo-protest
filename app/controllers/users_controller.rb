class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all
  
  index_action :bulkupload do
	 print "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
  end


	
	def index
      print "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
		print request.parameters
		hobo_index
	end

end
