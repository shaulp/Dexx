require 'properties'

class Template < ActiveRecord::Base
	validates :name, presence:true, uniqueness:true

	attr_accessor :properties # virtual fields
	has_many :cards

	after_initialize :init_properties
	before_save :pack_properties
	after_find :unpack_properties

	def init_properties
		@properties ||= []
	end
	def pack_properties
		m = properties.map {|p| p.pack}
		self.packed_properties = m.to_json
	end
	def unpack_properties
		@properties = []
		props = JSON.parse self.packed_properties, symbolize_names:true
		props.each {|p| add_property p}
	end
	def add_property(prop_def)
		@properties.each do |p|
			if p.name == prop_def[:name]
				errors.add p.name.to_sym, "i18> Property already exists"
				return nil
			end
		end
		p = Object.const_get("Properties::#{prop_def[:type]}").new(prop_def)
		@properties.push p
	end
	def remove_property(name)
		@properties.delete_if {|p| p.name==name}
	end
	def validate(card, prop_name, value)
		prop = get_property(prop_name)
		if prop.nil?
			nonexistant_property(card, prop_name) 
			return nil
		end
		val = prop.validate card, value
		return val
	end
	def get_property(name)
		(@properties.select {|p| p.name==name})[0]
	end
	def nonexistant_property(card, prop_name)
		card.add_error "i18> Property #{prop_name} does not exists"
	end
end
