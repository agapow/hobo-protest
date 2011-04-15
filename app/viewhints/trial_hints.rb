class TrialHints < Hobo::ViewHints

  # model_name "My Model"
  # field_names :field1 => "First Field", :field2 => "Second Field"
  
	field_help(
		:samples => "All samples that will be available for this trial.",
		:opening => "The time at which the trial is open and participating labs can view their trial shipment and enter results", 
		:closing => "The time at which the trial is closed and participating labs can no longer edit their trial shipment."
	)
	
  children :shipments, :samples
end
