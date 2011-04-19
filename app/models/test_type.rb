class TestType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title       :string
    units       :string
    description :string
    timestamps
  end

  has_many(:panel_test_types)
  has_many :panels, :through => :panel_test_types

  ## ACCESSORS
  def name
	 return title
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
