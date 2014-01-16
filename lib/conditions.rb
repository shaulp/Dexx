require 'lookups'

module Conditions

	def self.extract_conditions(condition_set, property)
		return nil if condition_set.nil?
		conditions = []
		condition_set.split(';').each do |text|
			new_cond = nil
			Condition_clauses.each do |reg,cond_class|
				if match = reg.match(text)
					new_cond = cond_class.new(match[1..-1]) rescue nil
					break
				end
			end
			if new_cond
				if property.applicable_condition? (new_cond) 
					condition << new_cond
				end
			else
				property.add_error "i18> Could not create condition from #{text}"
			end
		end
		return nil if conditions.empty?
		conditions
	end

	class Condition

		def initialize(params)
			# @condition = condition
		end
		def check(v)
			return true
		end
	end

	class Mandatory < Condition
		def check(v)
			raise ArgumentError.new if v.value.nil?
			raise ArgumentError.new if v.value.empty? && \
																 v.property.is_a?(Properties::StringProperty)
			return true
		rescue ArgumentError
			v.add_error "i18> A value must be supplied'."
			return false
		end
	end

	class Unique < Condition
	end

	class LengthAtLeast < Condition
		def initialize(params)
			@min_length = params[0].to_i
		end
		def check(v)
			raise ArgumentError if v.value.length < @min_length
			return true
		rescue ArgumentError
			v.add_error "i18> The value must be at least #{@min_length} caracters long."
			return false
		end
	end

	class LengthAtMost < Condition
		def initialize(params)
			@max_length = params[0].to_i
		end
		def check(v)
			raise ArgumentError if v.value.length > @max_length
			return true
		rescue ArgumentError
			v.add_error "i18> The value must not be longer than #{@max_length} caracters."
			return false
		end
	end

	class ScalarCheck < Condition
		def initialize(params)
			@scalar = params[0]
			@operator = params[1]
			@message = params[2]
		end
		def check(v)
			return true if v.value.send(@operator, @scalar)
			v.add_error @message
			return false
		end
	end

	class GreaterThan < ScalarCheck
		def initialize(params)
			params.push '>', "i18> The value must be greater than #{params[0]}."
			super params
		end
	end

	class LessThan < ScalarCheck
		def initialize(params)
			params.push '<', "i18> The value must be less than #{params[0]}."
			super params
		end
	end

	class GreaterOrEqual < ScalarCheck
		def initialize(params)
			params.push '>=', "i18> The value must be greater than or equal to #{params[0]}."
			super params
		end
	end

	class LessOrEqual < ScalarCheck
		def initialize(params)
			params.push '<=', "i18> The value must be less than or equal to #{params[0]}."
			super params
		end
	end

	class Pattern < Condition
	end

	class List < Condition
		def initialize(params)
			@list = params[0].split(/[<>]/)
			@list.delete ""
		end
		def check(v)
			@list.member?(v.value)
		end
	end

	class Link < Condition
		def check(v)
			Card.exists?(v.value)
		end
	end

	class Referrence <Condition
		def initialize(params)
			@template = Template.find(name:params[0])
			raise TypeError unless @template
			@property = template.get_property(params[1])
			raise TypeError unless @property
		end
		def check(v)
			cards = Lookups.card_with_properties @template, @property => v.value
			!cards.empty?
		end
	end

	Condition_clauses = {
		/^Mandatory$/i => Conditions::Mandatory,
		/^Unique$/i => Conditions::Unique,
		/^Max-length:(\d+?)$/i => Conditions::LengthAtMost,
		/^Min-length:(\d+?)$/i => Conditions::LengthAtLeast,
		/^<(\d+?)$/i => Conditions::LessThan,
		/^>(\d+?)$/i => Conditions::GreaterThan,
		/^<=(\d+?)$/i => Conditions::LessOrEqual,
		/^>=(\d+?)$/i => Conditions::GreaterOrEqual,
		/^List:(<[\w _']+(><[\w _']+)*>)$/ => Conditions::List,
		/^Link$/i => Conditions::Link,
		/^Ref:{([\w]+)\/([\w]+)}$/ => Conditions::Referrence
	}

end