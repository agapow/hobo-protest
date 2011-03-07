class TrialSeries < ActiveRecord::Base

	hobo_model # Don't put anything above this

	fields do
		title         :string
		description   :text
		timestamps
	end

   # each trial series can have several managers
   has_many :users, :through => :trial_series_managers, :accessible => true
   has_many :trial_series_managers, :dependent => :destroy

	## Permissions:
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
