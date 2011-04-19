class Panel < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
		title       :string, :required, :unique
		short_name  :string, :unique
		description :text
		note        :text
		timestamps
  end

  has_many :panel_test_types
  has_many :test_types, :through => :panel_test_types, :accessible => true

	## ACCESSORS:
	
	def name
		if short_name.blank?
			return title.blank? ? id.to_s() : title
		else
			return short_name
		end
	end
	
	
  # --- Permissions --- #

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
