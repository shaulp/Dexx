require 'validations'
#require 'conditions'

module Properties

	def Properties.valid_type?(property_name)
		ret = Properties.const_defined?(property_name.to_sym) rescue false
		return ret && property_name.to_sym != :Property
	end

	class Property
		attr_accessor :name, :validation, :errors

		def initialize(prop_def)
			@applicable_conditions ||= []
			@name=prop_def[:name]
			@validation = Validations::Validation.new prop_def[:validation], self
		end
		def type
			self.class.to_s
		end
		def convert(value)
			value.to_s
		end
		def applicable_condition?(c)
			if @applicable_conditions.member? c.class
				return true
			else
				add_error "i18> #{c.class} cannot be applied to a #{self.class}"
				return false
			end
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
		def add_error(msg)
			(@errors ||= []) << msg
		end
		def valid?
			(@errors ||= []).empty?
		end
	end

	class StringProperty < Property
		def initialize(prop_def)
			@applicable_conditions = [
				Conditions::Mandatory, Conditions::Unique, 
				Conditions::LengthAtLeast, Conditions::LengthAtMost, Conditions::GreaterThan, 
				Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
				Conditions::Pattern, Conditions::List, Conditions::Referrence]
			super prop_def
		end
	end

	class DecimalProperty < Property

		def initialize(prop_def)
			@applicable_conditions = [
				Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
				Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
				Conditions::List, Conditions::Referrence]

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
		def initialize(prop_def)
			@applicable_conditions = [
				Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
				Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
				Conditions::List, Conditions::Referrence]
			super prop_def
		end

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

	class LinkProperty < Property
		def convert(value)
			value.to_i<=0 ? nil : value.to_i
		end
	end
end
