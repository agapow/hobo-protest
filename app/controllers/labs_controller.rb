class LabsController < ApplicationController

  hobo_model_controller
  
  auto_actions :all
  
  def index
	# if the form has been submitted, try to parse upload
	req_params = request.parameters
	if req_params["submitted"] == "true"
		begin
			# check the params
			spreadsheet = req_params["spreadsheet"]
			if ! spreadsheet
				raise StandardError, "No spreadsheet attached."
			end
			# do the work
			Lab.bulkupload(spreadsheet, req_params["dryrun"],
				req_params["overwrite"])
			# appropriately report good result
			if req_params["dryrun"] == "1"
				flash[:success] = "The spreadsheet format appears fine."
			else
				flash[:success] = "The list of labs was updated sucessfully."
			end
		rescue StandardError => err
			flash[:error] = err.to_s
		end
	end
	
	# in any event, render the index
	hobo_index
  end

end
