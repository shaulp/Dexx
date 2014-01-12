require 'validations'
#require 'conditions'

module Properties

	def Properties.valid_type?(property_name)
		ret = Properties.const_defined?(property_name.to_sym) rescue false
		return ret && property_name.to_sym != :Property
	end

	class Property
		attr_accessor :name, :validation

		def initialize(prop_def)
			@name=prop_def[:name]
			@validation = Validations::Validation.new prop_def[:validation], self.type
		end
		def type
			self.class.to_s
		end
		def convert(value)
			value
		end
		def applicable_condition?(condition)
			false
		end
		def validate(card, raw_value)
			value = convert(raw_value)
			if value
				@validation.validate(card, self, value)
			else
				card.add_property_error self, "i18> Bad property value: #{self.class} / #{raw_value}"
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
		def applicable_condition?(condition)
			[Conditions::Mandatory, Conditions::Unique, Conditions::LengthAtLeast,
				Conditions::LengthAtMost, Conditions::GreaterThan, Conditions::LessThan,
				Conditions::GreaterOrEqual, Conditions::LessOrEqual, Conditions::Pattern, 
				Conditions::List, Conditions::Referrence
				].member? condition
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
		def applicable_condition?(condition)
			[Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
				Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
				Conditions::List, Conditions::Referrence
				].member? condition
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
		def applicable_condition?(condition)
			[Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
				Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
				Conditions::List, Conditions::Referrence
				].member? condition
		end
	end

	class ListProperty < Property
		def convert(value)
			value.to_s
		end
	end

	class LinkProperty < Property
		def convert(value)
			value.to_i<=0 ? nil : value.to_i
		end
	end
end
