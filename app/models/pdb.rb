require 'bio'
class Protein < ActiveRecord::Base
  attr_accessible :description, :id
  has_many :chains, :dependent => :destroy

  DNA_PATH = File.join(Settings.pdb_data_root, 'dna')
  RNA_PATH = File.join(Settings.pdb_data_root, 'rna')

  def self.build_pdb_db
    Dir.foreach(DNA_PATH) do |f|
      pdb = Bio::FlatFile.open(Bio::PDB, File.join(DNA_PATH, f)).entry
    end
  end

end
