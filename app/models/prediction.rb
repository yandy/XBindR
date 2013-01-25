class Prediction < ActiveRecord::Base
  attr_accessible :res_arr
  serialize :res_arr
  serialize :res_status

  def do_predict!
  	pass
  end
end
