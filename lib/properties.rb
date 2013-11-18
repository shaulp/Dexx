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
		def validate(prop_set)
			prop_set[:property] = self
			@validation.validate(prop_set)
		end
		def pack
			{type:type, name:name, validation:validation.to_s}
		end
	end

	class StringProperty < Property
		def validate(prop_set)
			prop_set[:value] = prop_set[:value].to_s
			super prop_set
		end
	end

	class DecimalProperty < Property
		def initialize(prop_def)
			@frac_digits = prop_def[:frac_digits]||2
			super prop_def
		end

		def validate(prop_set)
			f = Float(prop_set[:value]) rescue nil
			if f
				prop_set[:value] = f.round(@frac_digits)
				super prop_set
			else
				prop_set[:err].add "i18> Value is not a number"
			end
		end
	end

	class DateProperty < Property
		def validate(value)
			#if value.is_a? Date
			#	value
			#elsif value is_a? String
			#	Date.parse value rescue nil
			#else
			#	nil
			#end
		end
	end

	class ListProperty < Property
	end

end
