module Properties

	class Property
		attr_accessor :name, :type, :validation

		def initialize(name='', type='')
			@name=name
			@type=type
		end

		def validate(value)
			nil
		end
	end

	class StringProperty < Property
		def initialize(name='')
			super (name, 'String')
		end

		def validate(value)
			return value.to_s
		end
	end

	class DecimalProperty < Property
		def initialize(name='', frac_digits=2)
			@frac_digits = frac_digits
			super(name, 'Decimal')
		end

		def validate(value)
			value.to_d.round(@frac_digits)
		end
	end
end
