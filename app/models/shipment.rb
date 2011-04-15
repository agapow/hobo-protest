class Shipment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
	title :string
    timestamps
  end

	belongs_to(:trial)
	belongs_to(:lab)
	has_many(:sample_results, :accessible => true, :dependent => :destroy)

  # --- Permissions --- #

	## ACCESSORS:
	
	def name
		if title.blank?
			if lab_id
				return "#{id} (#{lab.name})"
			else
				return "#{id}"
			end
		else
			return title
		end
	end

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
