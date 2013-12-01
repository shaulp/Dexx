require 'validations'

module Properties

	class Property
		attr_accessor :name, :validation

		def initialize(prop_def)
			@name=prop_def[:name]
			@validation = Validations::Validation.new prop_def[:validation]
		end
		def type
			self.class.to_s
		end
		def convert(value)
			value
		end
		def validate(card, raw_value)
			value = convert(raw_value)
			if value
				@validation.validate(card, self, value)
			else
				card.add_property_error self, "i18> Type mismatch: #{self.class} / #{raw_value}"
				nil
			end
		end
		def pack
			{type:type, name:name, validation:validation.pack}
		end
	end

	class StringProperty < Property
		def convert(value)
			value.to_s
		end
	end

	class DecimalProperty < Property
		def initialize(prop_def)
			@frac_digits = prop_def[:frac_digits]||2
			super prop_def
		end
		def convert(value)
			f = Float(value) rescue nil
			if f
				f.round(@frac_digits)
			end
		end
	end

	class DateProperty < Property
		def convert(value)
			if value.is_a? DateTime
				value
			elsif value is_a? String
				DateTime.parse value rescue nil
			else
				nil
			end
		end
	end

	class ListProperty < Property
		def convert(value)
			value.to_s
		end
	end

end
