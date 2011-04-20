class TrialsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def show
	# if the form has been submitted, try to parse upload
	req_params = request.parameters
	if req_params["submitted"] == "true"
		dryrun = req_params["dryrun"] == "1"
		spreadsheet = req_params["spreadsheet"]
		data_type = req_params["data_type"]
		trial_id = params[:id]
		begin
			# check the params
			if ! spreadsheet
				raise StandardError, "No spreadsheet attached."
			end
			# do the work
			if data_type == "samples"
			 Samples.bulkupload(spreadsheet, dryrun, trial_id)
			else
			 Shipments.bulkupload(spreadsheet, dryrun, trial_id)
			end
			# appropriately report good result
			if dryrun
				flash[:success] = "The spreadsheet format appears fine. Records do not
					duplicate or overwrite any pre-existing."
			else
				flash[:success] = "The list of labs was updated sucessfully."
			end
		rescue StandardError => err
			flash[:error] = err.to_s
			raise
		end
	end
	
	# in any event, render the index
	hobo_show
  end
  
end
