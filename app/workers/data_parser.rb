#encoding: utf-8
class DataParser
  @queue = :data_parser

  def self.perform
    Pdb.build_pdb_db
  end
end
