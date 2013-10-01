class Template < ActiveRecord::Base
	validates :name, presence:true

	attr_accessor :properties # virtual field

	before_save :pack_properties
	after_find :unpack_properties
	after_initialize :init_properties

	def init_properties
		@properties ||= [] #!~!~!~!~
	end
	def pack_properties
		self.packed_properties = @properties.to_json #!~!~!~!~!
	end
	def unpack_properties
		@properties = (self.packed_properties||'').reverse
	end
end
