class TrialSeries < ActiveRecord::Base
   # TODO: need "did you really want" when deletion will delete trials too?
   
	hobo_model # Don't put anything above this

	fields do
		title         :string
		description   :text
		timestamps
	end

   # each trial series can have several managers
   has_many :users, :through => :series_managers, :accessible => true
   has_many :series_managers, :dependent => :destroy

   has_many :trials, :dependent => :destroy, :accessible => true
   
   ## Accessors:
   def name
      return title.blank? ? "Series #{id.to_s}" : title
   end
   
	## Permissions:
	
	# Only administrators can create series.
	def create_permitted?
		acting_user.administrator?
	end

   # Only administrators or series managers can edit series.
	def update_permitted?
		acting_user.administrator? || users.member?(acting_user)
	end

	# Only administrators can create series.
	def destroy_permitted?
		acting_user.administrator?
	end

	def view_permitted?(field)
      # TODO: who can see what about trials
		true
	end

end
