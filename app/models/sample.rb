class Sample < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title       :string
    description :text
    result       :float
    outcome     enum_string(:positive, :inconclusive, :negative), :default => :inconclusive
    note        :text
    timestamps
  end

  belongs_to :panel
	belongs_to(:trial)

	## ACCESSORS:

	def name
		return "#{title.blank? ? id.to_s() : title} (panel #{panel.name})"
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
