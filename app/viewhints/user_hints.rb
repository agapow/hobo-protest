class UserHints < Hobo::ViewHints

	# model_name "My Model"
	
	field_names({
		:trial_series => "Supervisor for",
		:trials => "Manager for"
	})
	
	field_help({
		:name => "The users full name.",
		:user_name => "An unqiue identifier that will be used to login.",
		:email_address => "If the password is lost, a reset link will be mailed to
			this address.",
		:administrator => "Admins can add and edit all content in the system,
			notably users, labs and trial series.",
		:trial_series => "What trial series can this user manage (add trials and
			managers to).",
		:trials => "What trials can this user manage (invite labs, add samples
			examine results).",
	})
	

  
end
