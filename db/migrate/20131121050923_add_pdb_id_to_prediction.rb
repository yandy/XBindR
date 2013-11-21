class AddPdbIdToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :pdb_id, :integer
  end
end
