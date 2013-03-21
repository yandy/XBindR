class ChangeResSeqToPredictions < ActiveRecord::Migration
  def change
    change_column :predictions, :res_seq, :string
    change_column :predictions, :res_status, :string
  end
end
