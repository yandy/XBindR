class AddProteinIdToChain < ActiveRecord::Migration
  def change
    add_column :chains, :protein_id, :string
  end
end
