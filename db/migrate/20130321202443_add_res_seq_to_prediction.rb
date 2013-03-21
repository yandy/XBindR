class AddResSeqToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :res_seq, :text
    remove_column :predictions, :res_arr
  end
end
