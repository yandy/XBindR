#encoding: utf-8
class ProgressPrediction
  @queue = :data_parser

  def self.perform pred, email
  	if pred.res_status.any?
  		ResultMailer.binding_prediction_mail(pred, email).deliver
  	else
  		pred.do_predict!
  		ResultMailer.binding_prediction_mail(pred, email).deliver
  	end
  end
end
