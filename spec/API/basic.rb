require 'rest-open-uri'
require 'json'

open('http://localhost:3000/templates.json', 
	:method => :post, 
	"content-type" => 'application/json',
	:body => {name:'test-template-1'}.to_json
	) do |f|
	f.each_line {|l| puts l}
end
