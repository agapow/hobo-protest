class Trial < ActiveRecord::Base

	hobo_model # Don't put anything above this

	fields do
		title         :string    # the name for the trial
		opening       :datetime  # the start time for the trial
		closing       :datetime  # the stop time for the trial
		timestamps
	end

   # each trial is part of a series
   belongs_to :trial_series
   
   # each trial can have several managers
   has_many :users, :through => :trial_managers, :accessible => true
   has_many :trial_managers, :dependent => :destroy

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
