require 'properties'

class Template < ActiveRecord::Base
	validates :name, presence:true

	attr_accessor :properties # virtual fields

	after_initialize :init_properties
	before_save :pack_properties
	after_find :unpack_properties

	def init_properties
		@properties ||= []
	end
	def pack_properties
		m=properties.map {|p| p.pack}
		self.packed_properties = m.to_json
	end
	def unpack_properties
		@properties = (self.packed_properties||'').reverse
	end
	def add_property(name, type, validation='')
		@properties.each do |p|
			if p.name == name
				errors.add :base, "E!"
				return nil
			end
		end
		p = Object.const_get(type).new name
		p.validation = validation 
		@properties.push p
	end
	def remove_property(name)
		@properties.delete_if {|p| p.name==name}
	end
	def action=(op)
		logger.info ">>>>> op:#{op}"
		action_details = JSON.parse op, symbolize_names:true
		logger.info ">>>>> action=#{action_details[:action]}"
	end
	def action
		""
	end
end
