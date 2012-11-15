class Protein < ActiveRecord::Base
  attr_accessible :description, :id
  has_many :chains, :dependent => :destroy
end
