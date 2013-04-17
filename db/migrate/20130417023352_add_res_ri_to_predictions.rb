class AddResRiToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :res_ri, :text
  end
end
