require 'conditions'

module Validations

	class Validation
		attr_accessor :card, :property, :value, :errors

		def initialize(condition_set)
			@conditions = Conditions::extract_conditions(condition_set)
		end
		def validate(prop_set)
			@card = prop_set[:card]
			@property = prop_set[:property]
			@value = prop_set[:value]
			@errors = 

			@conditions.reduce(true) {|is_valid, condition| 
				is_valid && condition.check(self)
			}
		end
		def add_error(message)
			@card.errors.add :base, message if @card && @card.errors
		end
	end

end