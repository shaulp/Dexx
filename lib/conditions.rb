module Conditions

		def self.extract_conditions(condition_set)
			return nil if condition_set.nil?
			conditions = []
			condition_set.split(';').each do |text|
				Condition_clauses.each do |reg,cond_class|
					if match = reg.match(text)
						conditions << cond_class.new(match[1..-1])
					end
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
			if v.property.is_a? Properties::StringProperty
				if v.value.nil? || v.value.empty?
					v.add_error "i18> A value must be supplied for '#{v.property.name}'"
					return false
				end
			end
			return true unless v.value.nil?
		end
	end

	class Unique < Condition
	end

	class LengthAtLeast < Condition
		def initialize(params)
			@min_length = params[0].to_i
		end
		def check(v)
			v.value.length >= @min_length
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