#!/usr/bin/env ruby

#	convert_to_json.rb	
#	
#	Take a single file in either CSV or YAML format and convert it to JSON format. To keep this
#	simple for users it will create the same filename but with a .json extension.
#	
#	convert_to_json.rb myfile.csv
#		outputs: myfile.json	
#
#	Author: ryanspaulding@gmail.com
###############################

require 'json'
require 'csv'
require 'yaml'

@error_message = "convert_to_json.rb takes a single argument of a text file that is in CSV or YAML format then outputs a file with the same name in JSON format.\n\t./convert_to_json.rb myfile.csv\n\t\tproduces myfile.json"
@filename = nil

if ARGV.length != 1 or ARGV[0].nil?
	puts @error_message
	exit(1)
else
	@filename = ARGV[0]
	# is it a file we can do anything with? Is it a file at all? 
	unless File.file?(@filename)
		puts "#{@filename} is not a file that convert_to_json.rb can use."
		exit(1)
	end	
	
	if @filename !~ /\.(csv|yaml)$/
		puts "Please select a different file in CSV or YAML format."
		exit(1)
	end
	
end

# extra check
if @filename.nil? 
	puts @error_message
	exit(1)
end

# get new filename for writting
if @filename =~ /\.csv/
	@json_file = "#{File.basename(@filename, ".csv")}.json" 
	begin
		# read in the whole CSV file and convert it to JSON
		@data = CSV.read(@filename).to_json
	rescue
		puts "Could not convert #{@filename} to JSON format. Please check to see if the file is in CSV format."
		exit(1)
	end
elsif @filename =~ /\.yaml/
	@json_file = "#{File.basename(@filename, ".yaml")}.json" 
	begin
		# read in the whole YAML file and convert it to JSON
		@data = YAML.load_file(@filename).to_json
	rescue
		puts "Could not convert #{@filename} to JSON format. Please check to see if the file is in YAML format."
		exit(1)
	end
end

# does the file already exist ? 
if File.file?(@json_file)
	puts "#{@json_file} already exists. Overwrite file? [y or n]:"
	overwrite_file = $stdin.gets.chomp 
	if overwrite_file !~ /[yY]/
		puts "Did not convert #{@filename} to JSON format."
		exit(0)
	end
end

begin
	@json_file_handle = File.new(@json_file, "w")
	@json_file_handle.write(@data)
	@json_file_handle.close
	puts "File converted successfully to #{@json_file}."
rescue
	puts "Could not save your converted JSON file to #{@json_file}. Please verify that you have permission to write to this location."
	exit(1)
end

