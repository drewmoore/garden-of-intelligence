class CreatePlants < ActiveRecord::Migration[7.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :botanical_name
      t.boolean :eatable
      t.string :description

      t.timestamps
    end
  end
end
