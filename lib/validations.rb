require 'conditions'

module Validations

	class Validation
		attr_accessor :card, :property, :value

		def initialize(condition_set)
			@conditions_text = condition_set # for packing
			@conditions = Conditions::extract_conditions(condition_set)
		end
		def validate(card, property, value)
			return true unless @conditions
			@card = card
			@property = property
			@value = value

			@conditions.reduce(true) {|is_valid, condition| 
				is_valid && condition.check(self)
			}
		end
		def add_error(message)
			@card.add_property_error property, message if @card && @card.errors
		end
		def pack
			@conditions_text
		end
	end

end