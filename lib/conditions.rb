module Conditions

		def self.extract_conditions(condition_set)
			return if condition_set.nil?
			condition_set.split(';').map do |text|
				Condition_clauses.select do |reg,cond_class|
					if match = reg.match(text)
						cond_class.new match[1..-1]
					end
				end
			end
		end

	class Condition

		def initialize(params)
			# @condition = condition
		end
		def check(card, property, value)
			return true
		end
	end

	class Mandatory < Condition
		def check(card, property, value)
			if property.is_a Properties::StringProperty
				return false if value.nil? || value.empty?
			end
			return true unless value.nil?
		end
	end

	class Unique < Condition
	end

	class LengthAtLeast < Condition
		def initialize(params)
			@min_length = params[0].to_i
		end
		def check(card, property, value)
			value.length >= @min_length
		end
	end

	class LengthAtMost < Condition
	end

	class GreaterThan < Condition
	end

	class LessThan < Condition
	end

	class GreaterOrEqual < Condition
	end

	class LessOrEqual < Condition
	end

	class Pattern < Condition
	end

	class List < Condition
	end

	class Referrence < Condition
	end

	Condition_clauses = {
		/^Mandatory$/i => Conditions::Mandatory,
		/^Unique$/i => Conditions::Unique,
		/^Max-length:(\d+?)$/i => Conditions::LengthAtMost,
		/^Min-length:(\d+?)$/i => Conditions::LengthAtLeast
	}

end