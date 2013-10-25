class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :template_id
      t.string :title
      t.text :properties

      t.timestamps
    end
  end
end
