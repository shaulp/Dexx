class Card < ActiveRecord::Base
	attr_accessor :properties # virtual field
	validates :template, presence:true
	validates :title, presence:true
	belongs_to :template

	after_initialize :init_properties
	before_save :pack_properties
	after_find :unpack_properties

	scope :from_template, lambda {|template_name|
		template = Template.find_by_name(template_name)
		if template
			where(template_id: template.id)
		else
			where(template_id: -1)
		end
	}

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
		errors.clear
		if template.validate self, name, value
			@properties[name] = value
		end
	end
	def get(name)
		if self.template && (p=self.template.get_property name )
			p.convert @properties[name]
		else
			add_error "i18> No such property #{name}"
		end
	end
	def add_property_error(property, message)
		errors.add property.name.to_sym, message
	end
	def add_error(message)
		errors.add :base, message
	end
end
