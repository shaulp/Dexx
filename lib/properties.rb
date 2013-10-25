module Properties

	class Property
		attr_accessor :name, :validation

		def initialize(prop_def)
			@name=prop_def[:name]
			@validation = prop_def[:validation]
		end
		def type
			self.class.to_s
		end
		def validate(value)
			value
		end
		def pack
			{type:type, name:name, validation:validation.to_s}
		end
	end

	class StringProperty < Property
		def validate(value)
			return value.to_s
		end
	end

	class DecimalProperty < Property
		def initialize(prop_def)
			@frac_digits = prop_def[:frac_digits]||2
			super prop_def
		end

		def validate(value)
			f = Float(value) rescue nil
			f.round(@frac_digits) if f 
		end
	end
end
