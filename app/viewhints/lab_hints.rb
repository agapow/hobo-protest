class LabHints < Hobo::ViewHints

	model_name "Participating lab"
	
	# field_names :field1 => "First Field", :field2 => "Second Field"
	
	field_help({
		:short_name => "An id or abbreviation to be used on labels or in tables."
	})
	
	children :shipments, :members
end
