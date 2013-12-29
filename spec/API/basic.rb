require 'rest-open-uri'
require 'json'

def create_template(name)
	open('http://localhost:3000/templates.json', 
		:method => :post, 
		"content-type" => 'application/json',
		:body => {name:name}.to_json
		) do |f|
		f.each_line {|l| puts l}
	end
end

def create_card(title, template_name)
	open('http://localhost:3000/cards.json', 
		:method => :post, 
		"content-type" => 'application/json',
		:body => {title:title, template_name:template_name}.to_json
		) do |f|
		f.each_line {|l| puts l}
	end
end

#create_template "test-template-1"
create_card "test-card-1", "test-template-1"