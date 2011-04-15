class Lab < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title          :string, :required, :unique
    short_name     :string, :unique, :limit => 16
    institute      :string
    street_address :string
    locality       :string
    region         :string
    postal_code    :string, :limit => 16
    country        :string
    timestamps
  end

   # each lab can have several members
   has_many(:users)

   # each lab can be in several trials
   #has_many(:trial_participants, :dependent => :destroy)
   #has_many(:trials, :through => :trial_participants)
	
	has_many(:shipments)

  # --- Permissions --- #

	def name
		if ! short_name.blank?
			return short_name
		elsif ! title.blank?
			return title
		else
			return id.to_s
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
