class LabsController < ApplicationController

  hobo_model_controller

  auto_actions :all

	def index
		print "*** In labs controller"
		req_params = request.parameters
		print req_params
		if req_params["_submit"] = "Upload"
			print Lab.instance_methods.sort
			Lab.bulkupload(req_params["spreadsheet"], req_params["dryrun"],
				req_params["overwrite"])
		end
		
		hobo_index
	end

end
