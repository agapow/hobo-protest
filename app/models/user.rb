require "spreadsheet_reader.rb"
require "protest_utils.rb"
require "pp"

class User < ActiveRecord::Base
	
	hobo_user_model # Don't put anything above this
	
	fields do
		name            :string, :required, :unique
		user_name       :string, :unique, :login => true
		email_address   :email_address, :required, :unique
		administrator   :boolean, :default => false
		timestamps
	end
	
	belongs_to :lab, :accessible => true


	## MUTATORS:
	# MUTATORS
	def self.bulkupload(spreadsheet, dryrun)
		## Preconditions:
		if ! spreadsheet
			flash[:error] = "No spreadsheet attached."
			return
		end
		## Main:
		# 1. read data & fill-in, check for obvious errors
		synonyms = {
			:user => :name,
			:id => :user_name,
			:short_name => :user_name,
			:email => :email_address
		}
		rdr = SpreadsheetReader::Reader.new(spreadsheet, synonyms)
		row_no = 0
		missing_required = []
		existing_users = []
		unknown_labs = []
		checked_recs = []
		rdr.read { |row|
			pp row
			pp row_no
			row_no += 1
			
			# validate: there must be a name
			if ! row[:name]
				missing_required << row_no
				break
			end
			if ! row[:email_address]
				missing_required << row_no
				break
			end
			
			# fillin: make sure there's an user_name
			if ! row[:user_name]
				row[:user_name] = ProtestUtils.str_to_id (row[:name])
			end
			
			# check: are there records already for this?
			if ! User.name_is(row[:name]).empty?
				existing_users << row[:name]
			end
			if ! self.user_name_is(row[:user_name]).empty?
				existing_users << row[:user_name]
			end
			
			# link
			if ! row[:lab].nil?
				my_lab = Lab.find_by_short_name(row[:lab])
				if my_lab.nil?
					unknown_labs << row[:lab]
				else
					row[:lab_id] = my_lab.id
				end
			end
			

			# filter out irrelevant & nil fields to prevent crash or security breach
			allowed_fields = [
				:name,
				:user_name,
				:email_address,
				:lab_id
			]
			checked_recs << row.reject { |key,value|
				key.nil? || (! allowed_fields.member?(key))
			}
		}
		
		# 2. if there are obvious errors
		error_msgs = []
		if ! missing_required.empty?
			error_msgs << "Some users are missing required information: rows #{missing_required.join(', ')}."
		end
		if ! existing_users.empty?
			error_msgs << "Some users are already in use: #{existing_users.join(', ')}."
		end
		
		if ! error_msgs.empty?
			raise StandardError, error_msgs.join(" ")
		end
		
		# 3. if not a dry run, save these suckers
		if ! dryrun
			checked_recs.each { |rec|
				new_rec = User.new(rec)
				new_rec.save()
			}
		end
	end
	
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
		
		# make signup impossible
		#create(:signup,
		#	:available_to => "Guest",
		#	:params => [
		#		# TODO: anyway of labelling fields other than hints?
		#		:name,
		#		:user_name,
		#		:email_address,
		#		:password,
		#		:password_confirmation
		#	],
		#	:become => :active
		#)
		
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
