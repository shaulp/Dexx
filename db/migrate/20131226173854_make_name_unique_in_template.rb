class MakeNameUniqueInTemplate < ActiveRecord::Migration
  def change
  	add_index :templates, :name, unique: true
  end
end
