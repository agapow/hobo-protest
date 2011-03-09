class TrialSeries < ActiveRecord::Base
   # TODO: need "did you really want" when deletion will delete trials too?
   
	hobo_model # Don't put anything above this

	fields do
		title         :string
		description   :text
		timestamps
	end

   # each trial series can have several managers
   # TODO: need to name this to something sensible
   has_many :series_managers, :dependent => :destroy
   has_many :supervisors, :through => :series_managers, :source => "User",
      :accessible => true

   # each trial series can have many trials, ordered by reverse closing date
   has_many :trials, :dependent => :destroy, :accessible => true,
      :order => 'closing DESC'
   
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
