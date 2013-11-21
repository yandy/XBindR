require 'bio'
class Pdb < ActiveRecord::Base
  attr_accessor :biopdb

  attr_accessible :description, :entry_id, :biopdb, :pdbfile, :ct
  has_many :chains, :dependent => :destroy
  has_many :predictions

end
