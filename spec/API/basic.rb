require 'rest-open-uri'
require 'json'
#require 'sourcify'

def rand_string(len)
	(0..len).map {(65+rand(26)).chr}.join
end

def dexx_end
	puts "end"
end

def assert(&blk)
	#puts blk.to_source(strip_enclosure:true) if $verbose
	dexx_call &blk
end

def unsert(&blk)
	#puts blk.to_source(strip_enclosure:true) if $verbose
	dexx_call false, &blk
end
def exec (&blk)
	blk.call
	puts "..Done"
end

def dexx_call(expect_pass=true)
	return unless block_given?
	$resp = yield
	if $resp["status"]=="ok"
		if $verbose
			puts "..OK" if expect_pass
			puts "..OK(test failed)" if !expect_pass
		else
			print "." if expect_pass
			print "=X=" if !expect_pass
		end
	else
		if expect_pass
			puts "\n#{$resp}\nExecution stopped!"
			exit
		else
			print "." unless $verbose
			puts "..#{$resp} (test passed)" if $verbose
		end
	end
end

def get_template(name)
	print "get_template '#{name}'" if $verbose
	resp=""
	open("http://localhost:3000/templates.json?name=#{name}", 
		:method => :get, 
		"content-type" => 'application/json'
		#:body => {"template" => {"name" => name}}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

def create_template(name)
	print "create_template '#{name}'" if $verbose
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

def delete_template(name)
	print "delete_template '#{name}'" if $verbose
	resp=""
	open("http://localhost:3000/templates/#{name}.json",
			:method => :delete, 
			"content-type" => 'application/json',
			:body => {name:name}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

def add_prop_to_template(id, name, type, validation)
	print "add_prop_to_template (#{id}): name: '#{name}' type: '#{type}' validation: '#{validation}'" if $verbose
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
	print "create_card '#{title}' on template '#{template_name}'" if $verbose
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

def set_card_property(cid, prop, value)
	print "set_card_property (#{cid}): prop: '#{prop}' value: '#{value}'" if $verbose
	resp=""
	open('http://localhost:3000/cards/set.json', 
		:method => :put, 
		"content-type" => 'application/json',
		:body => {id:cid, property:{name:prop, value:value}}.to_json
		) do |f|
		f.each_line {|l| resp << l}
	end
	JSON.parse(resp)
end

