#r = File.open("pokus.txt").read

require 'date'
require 'json'

r=$stdin.read
summary_section = false
resolution_section = false
summary = []
votings = []
resolution_header_exp = /^\|(.*)\|(\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}:\d{2}.\d{3})\s*\|/

r.split("\n").each{ |line|

	if line.match("SOMMAIRE")
	  summary_section = true
	  next
	end

	if summary_section
	  if line.match(resolution_header_exp)
	  	summary_section = false
	  else
	  	summary << line
	  end
	end

	if matches = line.match(resolution_header_exp)
	  id = matches[1].strip
	  @datetime = DateTime.parse(matches[2])
	  @current_res = id
	  resolution_section = true
	end

	if resolution_section
	  if matches = line.match(/^\|(\d{1,3})\s*\|([+-0])\s*\|$/)
	  	count = matches[1]
	  	@sign = matches[2]
	  elsif matches = line.match(/^([A-Z]*):\s*(.*)$/)
	  	fraction = matches[1]
	  	names = matches[2].split(', ')
	  	names.each{|name|
	  		#puts "#{@current_res}\t#{fraction}\t#{name}\t#{@sign}" if fraction == "EFDD" && name == "Mach"
	  		hlas = "for" if @sign=='+'
	  		hlas = "against" if @sign=='-'
	  		hlas = "abstention" if @sign=='0'
	  		votings << {voted_at: @datetime,
	  		voted: hlas,
	  		voting_topic: @current_res} if fraction == "EFDD" && name == "Mach"
	  	}
	  end
	end

}
puts JSON.pretty_generate(votings)
#puts "SUMMARY"
#puts summary
#puts "*"*20
