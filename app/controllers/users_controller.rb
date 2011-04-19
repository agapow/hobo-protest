class UsersController < ApplicationController

  hobo_user_controller

  auto_actions :all
  
  def index
	# if the form has been submitted, try to parse upload
	req_params = request.parameters
	if req_params["submitted"] == "true"
		dryrun = req_params["dryrun"] == "1"
		spreadsheet = req_params["spreadsheet"]
		begin
			# check the params
			if ! spreadsheet
				raise StandardError, "No spreadsheet attached."
			end
			# do the work
			User.bulkupload(spreadsheet, dryrun)
			# appropriately report good result
			if dryrun
				flash[:success] = "The spreadsheet format appears fine. Records do not
					duplicate or overwrite any pre-existing."
			else
				flash[:success] = "The list of users was updated sucessfully."
			end
		rescue StandardError => err
			flash[:error] = err.to_s
		end
	end
	
	# in any event, render the index
	hobo_index
  end

end
