class SampleType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title       :string
    description :string
    units       :string
    note        :string
    timestamps
  end

	has_many(:test_types, :accessible => true)

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
