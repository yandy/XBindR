class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.string :id

      t.timestamps
    end
  end
end
