require 'rest-open-uri'
require 'json'

def rand_string(len)
	(0..len).map {(65+rand(26)).chr}.join
end

def create_template(name)
	resp=""
	open('http://localhost:3000/templates.json', 
		:method => :post, 
		"content-type" => 'application/json',
		:body => {name:name}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

def add_prop_to_template(id, name, type, validation)
	resp=""
	open("http://localhost:3000/templates/add_property.json", 
		:method => :put, 
		"content-type" => 'application/json',
		:body => {id:id, property:{name:name, type:type, validation:validation}}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

def create_card(title, template_name)
	open('http://localhost:3000/cards.json', 
		:method => :post, 
		"content-type" => 'application/json',
		:body => {title:title, template_name:template_name}.to_json
		) do |f|
		f.each_line {|l| puts l}
	end
rescue Exception => msg
	puts msg
	puts e
end

resp = create_template "test-template-"+rand_string(5)
if resp["status"]=="ok"
	puts "New Template created id:#{resp["template"]["id"]} name:#{resp["template"]["name"]}"
	tid = resp["template"]["id"]
	resp = add_prop_to_template tid, "dec", "DecimalProperty", "<12"
	puts resp
else
	puts "Error creating template - #{resp["message"]}"
end


#puts "#{add_prop_to_template(23, "n2", "DecimalProperty", "Max-length:3")}"
#puts "#{add_prop_to_template(23, "n3", "DecimalProperty", "Max-length:3")}"
#create_card "test-card-1", "test-template-1"
#model={"a" => 1, "b" => {"c" => 3}}
#h= {"a" => 3, "b" => {"c" => 55}}
#puts clean_params model, h