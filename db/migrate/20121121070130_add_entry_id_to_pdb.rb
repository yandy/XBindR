class AddEntryIdToPdb < ActiveRecord::Migration
  def change
    add_column :pdbs, :entry_id, :string
  end
end
