class AddCutoffToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :cutoff, :string
  end
end
