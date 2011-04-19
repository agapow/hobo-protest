class PanelHints < Hobo::ViewHints

	# model_name "My Model"
	
	field_names(
		:title => "Name",
		:panel_test_types => "Possible test types"
	)
	
	field_help(
		:description => "Publicly available.",
		:note => "Private annotations."
	)
	
	children :panel_test_types
end
