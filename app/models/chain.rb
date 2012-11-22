class Chain < ActiveRecord::Base
  attr_accessible :name, :resdist
  belongs_to :pdb

  serialize :resdist
end
