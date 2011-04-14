# Test Roo for reading sample excel spreadsheets

# The reader should read a row from the passed spreadsheet and pass a hash of
# value-pairs to a block. It should expect a heading, but must allow for
# variable order of columns,allow for inconsistencies in naming, translate
# data into the most appropriate format. allow overriding for specific columns.

# NOTE: doco is a bit sketchy
# TODO: check file extensions?


### IMPORTS

require './excel_utils.rb'
require 'roo'
require 'pp'


### CONSTANTS & DEFINES

# base date for serial values.
JAN_1_1900 = Date.new(1900, 1, 1)

# regexes for converting numbers
INT_REGEX = /^[1-9]\d*$/
FLOAT_REGEX = /^\d+\.\d+$/
DATE_SPLIT_REGEX = /\/|\-|\./

# for cleaning out blank or unknown entries
# TODO: cope with case as well
UNKNOWN_STR_REGEX =  /\?|unknown/

# preferred date formats whe trying to guess what format a date is
DATE_FMTS = [
   # work from least ambiguous to most
   '%Y-%m-%d',
   '%d-%m-%Y',
   '%m-%d-%Y',
   '%d-%m-%y',
   '%y-%m-%d',
   '%m-%d-%y', 
]


### IMPLEMENTATION ###

module SpreadsheetReader

	# Test a condition and throw an exception on failure.
	#
	# @param            cond      a condition, test or boolean
	# @param [Class]    ex-class  the class of exception to be raised
	# @param [String]   msg       a message to include in the exception
	#
	# Why the frick doesn't Ruby have a proper assert?
	#
	def rtassert(cond, ex_class, msg)
		if (!cond)
			raise ex_class, msg
		end
	end
	
	# Sniff the format of a date string and then convert it to a date
	#
	# @param [String]   d   a date in various forms, e.g. 2000/2/29, 1-10-99
	#
	# An unfortunate necessity, given the what variety of formats could be expected.
	# It works through a global list of suggested formats and tries every one. If
	# that fails, it tries a brute force parse.
	#
	def parse_date_str (d)
		## Preconditions:
		# check format of date
		date_arr = d.split(DATE_SPLIT_REGEX)
		rtassert(date_arr.size() == 3, ArgumentError,
			"cant recognise format of date '#{d}'")
		# convert to hyphens as Ruby gets confused with slashes
		date_str = date_arr.join('-')
		## Main:
		# try each of the supplied date formats
		DATE_FMTS.each { |fmt|
			begin
				date_obj = Date.strptime(date_str, fmt)
				return date_obj
			rescue ArgumentError
				# pass
			end
		}
		# try a brute force approach
		begin
			date_obj = Date.parse(date_str)
			return date_obj      
		rescue
			pp date_arr
			raise ArgumentError, "can't recognise format of date '#{d}'"   
		end
	end
	
	
	# Convert an Excel serial-format date to a Ruby date object
	#
	# @param [Float,Fixnum,String]   s  an Excel serial value, e.g. 378956.0
	#
	def serial_to_date (s)
		# round down and convert from string if need be
		# zero day is actually "Jan 0" and indexing starts from 1, so subtract 2
		s = s.to_i() - 2
		# add to zero day
		return JAN_1_1900 + s
	end
	
	
	# Puzzle out the format of a date entry in a spreadsheet and return it.
	#
	# @param           d           the value to be interpreted
	# @param [Boolean] after_1925  expect dates to be 1925 or later
	#
	# A date in a spreadsheet cell could be in a number of formats. It could be
	# formatted as a date (and thus return as a float). It could be unformatted and
	# thus a string, but written as DD/MM/YY or DD/MM/YYYY or YYYY/MM/DD, etc. This
	# function examines the date and tries to guess which it is before returning the
	# value as a real date.
	#
	def interp_date (d, after_1925=true)
		# TODO: add argument for preferred/hinted format?
		# Main:
		date_obj = false
		# handle already converted values and serial values
		# NOTE: to test for a ruby class in a "case/when" statement, you pass in the
		# object. When clauses are tested with === and obj.class === obj (but
		# obj === obj.class
		case d
			# if no value
			when NilClass
				return nil
			# if already converted
			when Date
				date_obj = d
			# convert serial values
			when Float
				date_obj = serial_to_date(d)
			when Fixnum
				return serial_to_date(d)
			# otherwise must be a string
			when String
				d = d.strip()
				# if they leave it unknown
				if UNKNOWN_STR_REGEX.match(d)
					return nil
				end
				# is it a serial value as a string?
				if (INT_REGEX.match(d) || FLOAT_REGEX.match(d))
					pp d
					pp d.class
					date_obj = serial_to_date(d)
				else
					# otherwise must be a date string
					date_obj = parse_date_str(d)
				end
		end
		
		if date_obj
			# we have a date, do we have to adjust years?
			if after_1925
				if date_obj.year <= 25
					return Date.new(y=date_obj.year+2000, m=date_obj.month,
						d=date_obj.day)
				elsif (date_obj.year < 100) and (25 < date_obj.year)
					return Date.new(y=date_obj.year+1900, m=date_obj.month,
						d=date_obj.day)            
				end
			end
			return date_obj
		else
			# if you get here, it's in a format we don't understand or handle
			raise ArgumentError, "can't make date from #{d.class}"
		end
	end
	
	
	# Converts the string form of a number to the best-fitting numeric type.
	#
	# @param [String]   s   string or string-able object capturing a number
	#
	def str_to_number(s)
		val_str = s.to_s()
		if INT_REGEX.match(val_str)
			return val_str.to_i()
		elsif FLOAT_REGEX.match(val_str)
			return val_str.to_f()
		else
			raise ArgumentError, "can't understand numeric format '#{s}'"
		end
	end
	
	
	### IMPLEMENTATION ###
	
	# A Excel 95 spreadsheet reader that can clean up column names and convert data.
	#
	# Assumptions: The data is read off the first sheet of the workbook. The sheet
	# has column headers. Column names are cleaned up, so as to tolerate small
	# errors (see "read_headers"). Each row has the same number of entries /
	# columns.
	#
	# @example How to use this class
	#    rdr = XlsReader('my-excel.xls')
	#    rdr.read() { |rec| print rec }
	#
	class ExcelReader
		
		attr_accessor :wbook, :syn_dict
		
		# Initialise the reader.
		#
		# @param [String] infile   the path to the spreadsheet to be read in.
		# @param [Hash] syn_dict   a remapping of column names, to allow synonyms
		#
		# @example How to create a reader
		#    rdr = XlsReader('my-excel.xls')
		#    rdr = XlsReader('my-excel.xls', {'foo_bar'=> 'foobar'})
		#
		def initialize(infile, syn_dict={})
			if (infile[/\.xls$/] != nil)
				@wbook = Excel.new(infile)
			elsif (infile[/\.xlsx$/] != nil)
				@wbook = Excelx.new(infile)
			end
			# NOTE: in roo, you don't select a worksheet, you name the current one
			@wbook.default_sheet = wbook.sheets.first
			@syn_dict = syn_dict
		end
		
		# Read the sheet, and return each non-header row to the passed block.
		#
		# This first reads the headers and cleans them up (see "read_headers"). When
		# each row is read, the values are stored in a hash with the cleaned up
		# column names as keys. If a method exists called "method_<key>", this is
		# used to convert the value. Spreadsheet seems to convert floats but dates
		# are returned as Excel serial values.
		#
		# @param [Block] blk  An executable block
		#
		def read(&blk)
			## Preconditions:
			# NOTE: you can't grab a row or just read a line in roo, you have to ask
			# about the bounds and explcitly iter over the cell contents. 
			row_start = @wbook.first_row
			row_stop = @wbook.last_row
			col_start = @wbook.first_column
			col_stop = @wbook.last_column
			if row_start != 1
				raise RuntimeError, "data must start on the first row not #{row_start}"
			end
			if col_start != 1
				raise RuntimeError, "data must start in the first column not #{col_start}"
			end      
			# Main:
			# grab and parse headers
			headers = read_headers(col_stop)
			# read each row
			(2..row_stop).each { |i|
				row_data = (1..col_stop).collect { |j| @wbook.cell(i,j) }   
				row_zip = headers.zip(row_data).flatten()
				row_hash = Hash[*row_zip]
				row_hash.each_pair { |k,v|
					meth_name = "convert_#{k}"
					if (self.respond_to?(meth_name))
						row_hash[k] = self.send(meth_name, v)
					else
						row_hash[k] = convert(v)
					end
				}
				blk.call(row_hash)
			}
		end
		
		# Return the canonical set of headers.
		#
		# This makes everything lowercase, strips flankning space, and substitutes
		# underscores for spaces. Override to validate or for further process headers.
		#
		def read_headers (col_stop)
			# collect header row
			headers = (1..col_stop).collect { |j|
				@wbook.cell(1,j)
			}
			# drop case, strip flanking spaces, replace gaps with underscores
			return headers.collect { |h|
				h_str = h.downcase.strip.gsub(' ', '_')
				@syn_dict.fetch(h_str, h_str)
			}
		end
		
		# General conversion of spreadsheet cell values 
		def convert(val)
			# clean up strings and return nil for 
			if val.class == String
				val.strip!()
				if ["?", "unknown"].member?(val.downcase())
					return nil
				end
			end
			return val
		end
		
		def convert_collected (val)
			# automagically called by read for collected field
			return interp_date(val)
		end
		
		def convert_avc_doi (val)
			# automagically called by read for avc_doi field
			return interp_date(val)
		end
		
	end

end


### END ###
