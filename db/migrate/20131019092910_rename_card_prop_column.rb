class RenameCardPropColumn < ActiveRecord::Migration
  def change
  	rename_column :cards, :properties, :packed_properties
  end
end
