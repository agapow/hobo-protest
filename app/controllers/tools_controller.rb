class ToolsController < ApplicationController

  hobo_controller

  def index; end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end
  
	def upload_samples
		#session[:results] = process_form(ToolForms::UploadExcelToolForm, request)
	end
	
	def upload_shipments
		session[:results] = process_form(ToolForms::ExtendedQueryToolForm, request)
	end
	
	def upload_users
		session[:results] = process_form(ToolForms::GraphResistToolForm, request)
	end

	def upload_labs
		session[:results] = process_form(ToolForms::GraphResistToolForm, request)
	end
	
end
