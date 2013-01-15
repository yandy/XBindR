class AddResStatusToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :res_status, :text
  end
end
