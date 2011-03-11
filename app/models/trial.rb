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
   
   ## each trial can have several managers
   has_many(:trial_managers, :dependent => :destroy)
   has_many(:managers, :through => :trial_managers, :accessible => true,
      :class_name => "User")

   # each trial can have several labs invited to it
   has_many(:trial_participants, :dependent => :destroy)
   has_many(:participating_labs, :through => :trial_participants,
      :accessible => true, :class_name => "User")
   
   ## Accessors:
   
   # Each trial can have many supervisors via the parent trial series
   #
   def supervisors
      return trial_series.supervisors
   end
   
   # Return the parent (owning) series
   #
   # Just a convenience method.
   #
   def series
      return trial_series
   end
   
   # Is this trial open for submissions?
   #
   def is_open?
      return state == :open
   end
   
   # What state is this trial in - is it time for submissions, before or after?
   #
   def state
      # pending, open, closed
      now = Time.now
      if now < opening
         return :pending
      elsif now < closed
         return :open
      else
         return :closed
      end
   end

	## Permissions:
	def create_permitted?
		acting_user.administrator? || (! acting_user.supervisor_of.empty?)
	end

   # Trials can only be editted by admins, supervisors or managers
	def update_permitted?
		acting_user.administrator? || managers.member?(acting_user) ||
         supervisors.member?(acting_user)
	end
	
	def destroy_permitted?
		acting_user.administrator? || supervisors.member?(acting_user)
   end

	def view_permitted?(field)
		true
	end

end
