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
		cards
	end

end