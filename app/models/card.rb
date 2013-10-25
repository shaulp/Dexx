class Card < ActiveRecord::Base
	attr_accessor :properties # virtual field
	validates :template, presence:true
	validates :title, presence:true
	belongs_to :template

	after_initialize :init_properties
	before_save :pack_properties
	after_find :unpack_properties

	def init_properties
		@properties ||= {}
	end
	def pack_properties
		self.packed_properties = @properties.to_json
	end
	def unpack_properties
		@properties = JSON.parse self.packed_properties
	end
	def set(name, value)
		if template.validate name:name, value:value, err:errors
			@properties[name] = value
		end
	end
	def get(name)
		@properties[name]
	end
end
