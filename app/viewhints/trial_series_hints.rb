class TrialSeriesHints < Hobo::ViewHints

  # model_name "My Model"
  
  field_names({
	 :users => "Managers",
	 :field2 => "Second Field"
  })
  
  field_help({
	 :users => "Series managers can create and edit trials and assign trial
		managers."
  })
  
  #children :trials
  
end
