class ChangeColumnToPredictions < ActiveRecord::Migration
  def change
    change_column :predictions, :cutoff, :float
  end
end
