class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :packed_properties

      t.timestamps
    end
  end
end
