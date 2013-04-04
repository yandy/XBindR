#encoding: utf-8
class DataImporter
  @queue = :data_importer

  def self.perform
    Pdb.build_pdb_db
  end
end
