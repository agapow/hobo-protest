class TrialSeriesHints < Hobo::ViewHints

  # model_name "My Model"
  
  field_names({
	 :field2 => "Second Field"
  })
  
  field_help({
	 :supervisors => "Series supervisors can create trials in the series and
		assign trial managers to them."
  })
  
  #children :trials
  
end
