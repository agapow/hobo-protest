class SampleTypeHints < Hobo::ViewHints

  # model_name "My Model"

	field_names(
		:test_types => "Possible tests"
	)
	
	field_help(
		:units => "The units of measurement used for this test. This is not used in calculations and is simply to help users be consistent.",
		:test_types => "Tests that can be used on this sample type."
	)
	
  children :test_types
end
