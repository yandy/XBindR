class Chain < ActiveRecord::Base
  attr_accessible :id
  belongs_to :protein
end
