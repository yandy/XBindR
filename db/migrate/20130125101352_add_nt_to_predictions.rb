class AddNtToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :nt, :integer
  end
end
