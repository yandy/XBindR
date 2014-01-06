class ChangePredictedToPrediction < ActiveRecord::Migration
  def up
    rename_column :predictions, :predicted, :pdb_flag
    change_column_default :predictions, :pdb_flag, false
  end

  def down
    rename_column :predictions, :pdb_flag, :predicted
  end
end
