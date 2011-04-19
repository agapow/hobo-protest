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
	def self.bulkupload(spreadsheet, dryrun)
		## Preconditions:
		if ! spreadsheet
			flash[:error] = "No spreadsheet attached."
			return
		end
		## Main:
		# 1. read data & fill-in, check for obvious errors
		synonyms = {
			:name => :title,
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
		missing_titles = []
		existing_titles = []
		existing_short_names = []
		checked_recs = []
		rdr.read { |row|
			row_no += 1
			# required fields: there must be a name
			if ! row[:title]
				missing_titles << row_no
				# for later checks
				row[:title] = ''
				break
			end
			# fillin: make sure there's an id
			if ! row[:short_name]
				row[:short_name] = ProtestUtils.str_to_id (row[:title])
			end
			# duplicates: are there records already for this?
			if ! Lab.short_name_is(row[:short_name]).empty?
				existing_titles << row[:short_name]
			end
			if ! self.title_is(row[:title]).empty?
				existing_titles << row[:title]
			end
			
			# filter out irrelevant & nil fields to prevent crash or security breach
			allowed_fields = [
				:title,
				:short_name,
				:institute,
				:street_address,
				:locality,
				:region,
				:postal_code,
				:country,
				:contact
			]
			checked_recs << row.reject { |key,value|
				key.nil? || (! allowed_fields.member?(key))
			}
		}
		
		# 2. if there are any errors, produce error message and throw
		error_msgs = []
		if ! missing_titles.empty?
			error_msgs << "Some labs are missing names: #{missing_titles.join(', ')}."
		end
		if ! existing_titles.empty?
			error_msgs << "Some lab names or short names are already in use: #{existing_titles.join(', ')}."
		end
		
		if ! error_msgs.empty?
			raise StandardError, error_msgs.join(" ")
		end
		
		# 3. if you reached here and if not a dry run, save these suckers
		if ! dryrun
			checked_recs.each { |rec|
				new_rec = Lab.new(rec)
				new_rec.save()
			}
		end
	end

	# --- Permissions --- #

	def name
		return "#{title} (#{short_name})"
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
