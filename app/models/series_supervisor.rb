class SeriesSupervisor < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
  end

   belongs_to :trial_series
   belongs_to :supervisor, :class_name => "User"

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
