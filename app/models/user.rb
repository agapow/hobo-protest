class User < ActiveRecord::Base
	
	hobo_user_model # Don't put anything above this
	
	fields do
		name            :string, :required, :unique
		user_name       :string, :unique, :login => true
		email_address   :email_address, :required, :unique
		administrator   :boolean, :default => false
		timestamps
	end
	
	# each trial series can have several supervisors
	has_many :series_supervisors, :dependent => :destroy, :foreign_key => "supervisor_id"
	has_many :trial_series, :through => :series_supervisors, :accessible => true
	
	# each trial can have several managers
	has_many :trial_managers, :dependent => :destroy, :foreign_key => "manager_id"
	has_many :trials, :through => :trial_managers, :accessible => true

	# each lab can have several members
	has_many :lab_members, :dependent => :destroy, :foreign_key => "member_id"
	has_many :labs, :through => :lab_members, :accessible => true

	## Lifecycles:
	
	# This gives admin rights to the first sign-up.
	# Just remove it if you don't want that
	# This gives admin rights to the first sign-up.
	# Just remove it if you don't want that
	before_create { |user|
		user.administrator = true if !Rails.env.test? && count == 0
	}

	lifecycle do
		state(:active, :default => true)
		
		create(:signup,
			:available_to => "Guest",
			:params => [
				# TODO: anyway of labelling fields other than hints?
				:name,
				:user_name,
				:email_address,
				:password,
				:password_confirmation
			],
			:become => :active
		)
		
		transition(:request_password_reset, { :active => :active }, :new_key => true) do
			UserMailer.deliver_forgot_password(self, lifecycle.key)
		end
		
		transition(:reset_password, { :active => :active },
			:available_to => :key_holder,
			:params => [ :password, :password_confirmation ]
		)
	
	end

	## Accessors:
	def supervisor_of
		return trial_series
	end
	
	def manager_of
		return trials
	end	
	
	## Permissions:
	def create_permitted?
		# Only administrators can directly create users 
		acting_user.administrator?
	end

	def update_permitted?
		# Only the administrator or the user themselves can edit user details.
		# The user cannot alter their user_name after creation.
		acting_user.administrator? || (acting_user == self && only_changed?(
				:name,
				:user_name,
				:email_address,
				:crypted_password,
				:current_password,
				:password,
				:password_confirmation
			)
		)
		# Note: crypted_password has attr_protected so although it is permitted
		# to change, it cannot be changed directly from a form submission.
	end

	def destroy_permitted?
		# Only the administrator can delete users.
		acting_user.administrator?
	end

	def view_permitted?(field)
		true
	end

end
