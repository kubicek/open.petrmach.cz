require 'open-uri'

date = Dir.glob("./records/*.doc").sort.last.to_s.match(/(\d+)/)[1]
puts "Last #{date}"
Date.parse(date).upto(Date.today).collect{|d| d.strftime("%Y%m%d")}[2..-1].each{ |date|
  puts date
  data = open("http://www.europarl.europa.eu/sides/getDoc.do?pubRef=-//EP//NONSGML+PV+#{date}+RES-RCV+DOC+WORD+V0//EN&language=EN").read
  if data.match(/<td class="reference" align="left">Application error<\/td>/)
    puts "404"
  else
    File.open("records/#{date}.doc",'w+') { |f|
  	  f << data
    }
  end
}