module Properties

	class Property
		attr_accessor :name, :type, :validation

		def validate(value)
			nil
		end
	end

	class StringProperty < Property
		def validate(value)
			return value.to_s
		end
	end

	class DecimalProperty < Property
		def initialize(frac_digits=2)
			@frac_digits = frac_digits
			super
		end

		def validate(value)
			value.to_d.round(@frac_digits)
		end
	end
end
