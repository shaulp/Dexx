module Properties

	class Property
		attr_accessor :name, :validation

		def initialize(name='')
			@name=name
		end
		def type
			self.class.to_s
		end
		def validate(value)
			nil
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
		def initialize(name='', frac_digits=2)
			@frac_digits = frac_digits
			super name
		end

		def validate(value)
			value.to_d.round(@frac_digits)
		end
	end
end
