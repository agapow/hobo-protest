class SampleResult < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
		title     :string
		result    :float
		outcome    enum_string(:negative, :ambiguous, :positive), :default => :ambiguous
		timestamps
  end

	belongs_to(:shipment)
	belongs_to(:sample)


	def name		
		if title.blank?
			parts = []
			if (shipment_id && shipment.lab_id)
				parts << shipment.lab.name
			end
			if (sample_id && sample.panel_id)
				parts << sample.panel.name
			end
			parts << id.to_s
			return parts.join(' ')		
		else
			return title
		end
	end

  # --- Permissions --- #
  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator? || only_changed?(:result, :outcome)
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    if acting_user.administrator?
    	return true
	else
		if [:sample].member?(field)
			return false
		else
			return true
		end
	end
  end

end
