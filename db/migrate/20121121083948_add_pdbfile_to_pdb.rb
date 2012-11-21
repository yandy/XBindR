class AddPdbfileToPdb < ActiveRecord::Migration
  def change
    add_column :pdbs, :pdbfile, :string
  end
end
