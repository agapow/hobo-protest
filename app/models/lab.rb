class Lab < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title          :string
    short_name     :string
    institute      :string
    street_address :string
    locality       :string
    region         :string
    postal_code    :string
    country_name   :string
    timestamps
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
