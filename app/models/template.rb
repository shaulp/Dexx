require 'properties'

class Template < ActiveRecord::Base
	validates :name, presence:true

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
				errors.add :base, "i18> Property '#{p.name}' already exists"
				return nil
			end
		end
		p = Object.const_get("Properties::#{prop_def[:type]}").new(prop_def)
		@properties.push p
	end
	def remove_property(name)
		@properties.delete_if {|p| p.name==name}
	end
	def validate(prop_set)
		prop = get_property(prop_set[:name])
		return nonexistant_property(prop_set) if prop.nil?
		val = prop.validate prop_set
		return inavlid_property_value(prop_set) if val.nil?
		return val
	end
	def get_property(name)
		(@properties.select {|p| p.name==name})[0]
	end
	def inavlid_property_value(prop_set)
			prop_set[:err].add :base, "i18> '#{prop_set[:value]}' is not a valid value for '#{prop_set[:name]}'"
	end
	def nonexistant_property(prop_set)
		prop_set[:err].add :base, "i18> Nonexistant property '#{prop_set[:name]}'"
	end
end
