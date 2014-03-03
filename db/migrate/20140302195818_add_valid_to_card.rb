class AddValidToCard < ActiveRecord::Migration
  def change
  	add_column :cards, :valid, :boolean
  end
end
