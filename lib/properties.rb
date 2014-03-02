require 'validations'
#require 'conditions'

module Properties

	def Properties.valid_type?(property_name)
		ret = Properties.const_defined?(property_name.to_sym) rescue false
		return ret && property_name.to_sym != :Property
	end

	class Property
		attr_accessor :name, :validation, :errors, :delete_key

		ApplicableConditions = []
		def self.applicable_condition?(c)
			if ApplicableConditions.member? c.class
				return true
			else
				add_error "i18> #{c.class} cannot be applied to a #{self.class}"
				return false
			end
		end

		def initialize(prop_def)
			@name = prop_def[:name]
			@validation = Validations::Validation.new prop_def[:validation], self
			@delete_key = prop_def[:delete_key]
		end
		def type
			self.class.to_s
		end
		def convert(value)
			value.to_s
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
			{type:type, name:name, validation:validation.pack, delete_key:delete_key}
		end
		def add_error(msg)
			(@errors ||= []) << msg
		end
		def valid?
			(@errors ||= []).empty?
		end
	end

	class StringProperty < Property
		ApplicableConditions = [
			Conditions::Mandatory, Conditions::Unique, 
			Conditions::LengthAtLeast, Conditions::LengthAtMost, Conditions::GreaterThan, 
			Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
			Conditions::Pattern, Conditions::List, Conditions::Referrence]

		def self.applicable_condition?(c)
			ApplicableConditions.member? c.class
		end

		def initialize(prop_def)
			super prop_def
		end
		def is_condition
		end
	end

	class DecimalProperty < Property
		attr_accessor :frac_digits
		ApplicableConditions = [
			Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
			Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
			Conditions::List, Conditions::Referrence]

		def self.applicable_condition?(c)
			return false unless ApplicableConditions.member? c.class	
		end

		def initialize(prop_def)
			frac_digits = prop_def[:frac_digits]||2
			super prop_def
		end
		def convert(value)
			f = Float(value) rescue nil
			if f
				f.round(frac_digits)
			end
		end
	end

	class DateProperty < Property
		ApplicableConditions = [
			Conditions::Mandatory, Conditions::Unique, Conditions::GreaterThan, 
			Conditions::LessThan, Conditions::GreaterOrEqual, Conditions::LessOrEqual, 
			Conditions::List, Conditions::Referrence]
		def self.applicable_condition?(c)
			return false unless ApplicableConditions.member? c.class	
		end
		def initialize(prop_def)
			super prop_def
		end

		def convert(value)
			if value.is_a? DateTime
				value
			elsif value.is_a? String
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
