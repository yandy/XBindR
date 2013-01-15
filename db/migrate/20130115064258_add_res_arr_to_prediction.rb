class AddResArrToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :res_arr, :text
  end
end
