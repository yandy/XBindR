class AddNameToChain < ActiveRecord::Migration
  def change
    add_column :chains, :name, :string
  end
end
