require 'csv'
require_relative 'parser'

parser = Parser.new

time_data = parser.time_plotdata
puts "\n"
p time_data

File.open('pq.csv', 'w+') do |file|
  ['Find', 'Pull'].each do |mthd|
    output_string = "#{mthd}:, \nsize,time\n"
    output_string << CSV.generate do |csv|
      time_data[mthd.downcase].each {|pair| csv << pair }
    end
    output_string << " , \n , \n"
    file.write(output_string)
  end
end
