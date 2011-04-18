require "spreadsheet_reader.rb"
require "protest_utils.rb"
require "pp"

class Lab < ActiveRecord::Base

	hobo_model # Don't put anything above this

	fields do
		title            :string, :required, :unique
		short_name       :string, :unique, :limit => 16
		institute        :string
		street_address   :string
		locality         :string
		region           :string
		postal_code      :string, :limit => 16
		country          :string
		contact          :email_address
		timestamps
	end

	 # each lab can have several members
	 has_many(:users)

	 # each lab can be in several trials
	 #has_many(:trial_participants, :dependent => :destroy)
	 #has_many(:trials, :through => :trial_participants)
	
	has_many(:shipments)

	# MUTATORS
	def self.bulkupload(spreadsheet, dryrun, overwrite)
		## Preconditions:
		if ! spreadsheet
			flash[:error] = "No spreadsheet attached."
			return
		end
		## Main:
		synonyms = {
			:name => :name,
			:id => :short_name,
			:address => :street_address,
			:postcode => :postal_code,
			:post_code => :postal_code,
			:zip_code => :postal_code,
			:zipcode => :postal_code,
			:email => :contact,
			:contact_email => :contact
		}
		
		rdr = SpreadsheetReader::Reader.new(spreadsheet, synonyms)
		row_no = 0
		missing_names = []
		rdr.read { |row|
			pp row
			pp row_no
			row_no += 1
			is_valid = true
			# validate: there must be a name
			if ! row[:name]
				missing_names << row_no
				is_valid = false
			end
			if ! row[:short_name]
				row[:short_name] = ProtestUtils.str_to_id (row[:name])
			end
			
			if is_valid and ! dryrun
				# do the saving
				# filter for non-nil fields
				fields = row.reject {|k,v| v.nil?}
				# fetch record & check for overwrite
				rec = Lab.new()
			end
			pp row
			pp fields

		}
		if ! missing_names.empty?
			raise StandardError, "some labs are missing names: #{missing_names.join(' ')}"
		end
		
	end

	# --- Permissions --- #

	def name
		if ! short_name.blank?
			return short_name
		elsif ! title.blank?
			return title
		else
			return id.to_s
		end
	end

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
