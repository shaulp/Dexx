require 'conditions'

module Validations

	class Validation
		def initialize(condition_set)
			@conditions = Conditions::extract_conditions(condition_set)
		end
		def validate(card, property, value)
			@conditions.reduce(true) {|is_valid, condition| 
				is_valid && condition.check(card, property, value)
			}
		end
	end

end