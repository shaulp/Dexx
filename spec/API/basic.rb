require 'rest-open-uri'
require 'json'

def rand_string(len)
	(0..len).map {(65+rand(26)).chr}.join
end

def dexx_end
	puts "end"
end

def dexx_call(expect_pass=true)
	return unless block_given?
	$resp = yield
	if $resp["status"]=="ok"
		print "." if expect_pass
		print "X" if !expect_pass
	else
		if expect_pass
			puts "\n#{$resp}\nExecution stopped!"
			exit
		else
			print "."
		end
	end
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
	resp=""
	open('http://localhost:3000/cards.json', 
		:method => :post, 
		"content-type" => 'application/json',
		:body => {title:title, template_name:template_name}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

tname = "test-template-"+rand_string(5)
dexx_call { create_template tname }
tid = $resp["template"]["id"]
#dexx_call (false) { add_prop_to_template tid, "dec", "DecimalProperty", "Max-length:3" }
#dexx_call { add_prop_to_template tid, "dec", "DecimalProperty", "<33" }
#dexx_call { add_prop_to_template tid, "str", "StringProperty", "Max-length:10" }
#dexx_call { add_prop_to_template tid, "dat", "DateProperty", "" }

cname = "test-card-"+rand_string(5)
dexx_call { create_card cname, tname }

dexx_end

#create_card "test-card-1", "test-template-1"
#model={"a" => 1, "b" => {"c" => 3}}
#h= {"a" => 3, "b" => {"c" => 55}}
#puts clean_params model, h