#encoding: utf-8
class DataImporter
  @queue = :high

  def self.perform
    Pdb.build_pdb_db
  end
end
