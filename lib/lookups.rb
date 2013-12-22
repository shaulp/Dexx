module Lookups
	def Lookups.cards_with_properties(template, properties)
		condition_clauses = []
		properties.each_pair do |property, value|
			condition_clauses << "packed_properties like '%\"#{property.name}\":\"#{value}\"%'"
		end
		prop_clause = condition_clauses.join ' and '
		puts prop_clause
		Card.where(template_id:template.id).where(prop_clause)
	end
end