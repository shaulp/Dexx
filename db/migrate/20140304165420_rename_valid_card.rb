class RenameValidCard < ActiveRecord::Migration
  def change
  	rename_column :cards, :valid, :is_valid
  end
end
