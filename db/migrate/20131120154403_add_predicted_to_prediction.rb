class AddPredictedToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :predicted, :boolean
  end
end
