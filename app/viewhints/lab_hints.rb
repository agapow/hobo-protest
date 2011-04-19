class LabHints < Hobo::ViewHints

	model_name "Participating lab"
	
	field_names({
		:title => "Name",
		:users => "Members"
	})
	
	field_help({
		:short_name => "An id or abbreviation to be used on labels or in tables."
	})
	
	children :shipments, :users
end
