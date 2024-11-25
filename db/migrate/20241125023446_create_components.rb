class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.string :component_type
      t.integer :x
      t.integer :y
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
