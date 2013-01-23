class Prediction < ActiveRecord::Base
  attr_accessible :res_arr

  def send_result email
  end

end
