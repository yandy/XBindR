class AddResdistToChain < ActiveRecord::Migration
  def change
    add_column :chains, :resdist, :text
  end
end
