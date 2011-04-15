class SampleHints < Hobo::ViewHints

	# model_name "My Model"

	# field_names :field1 => "First Field", :field2 => "Second Field"

	field_help(
		:title => "The private name for the sample. Trial participants will
			not see this.",
		:description => "Publicly available.",
		:note => "Private annotations."
	)

	# children :primary_collection1, :aside_collection1, :aside_collection2
end
