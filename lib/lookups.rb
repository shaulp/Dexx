module Lookups

	def Lookups.cards_with_properties(properties)
		cards = Card.all
		properties.each_pair do |property, value|
			if property=="template"
				cards = cards.where(template_id:value.id)
			elsif property=="title"
				cards = cards.where(title:value)
			else
				cards = cards.where('packed_properties like ?', "%\"#{property}\":\"#{value}\"%")
			end
		end
		#if properties
		#	condition_clauses = []
		#	properties.each_pair do |property, value|
		#		cards = cards.where('packed_properties like ?', "%\"#{property.name}\":\"#{value}\"%")
		#		#condition_clauses << "packed_properties like '%\"#{property.name}\":\"#{value}\"%'"
		#	end
		#	#prop_clause = condition_clauses.join ' and '
		#	#cards = cards.where(prop_clause)
		#end
		cards
	end

end