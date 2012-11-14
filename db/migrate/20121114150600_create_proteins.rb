class CreateProteins < ActiveRecord::Migration
  def change
    create_table :proteins do |t|
      t.string :id
      t.text :description

      t.timestamps
    end
  end
end
