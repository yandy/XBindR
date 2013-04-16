#encoding: utf-8
class ResultMailer < ActionMailer::Base

  default from: "XBindR <no-reply@cbi.seu.edu.cn>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inform_mailer.send_notice.subject
  #
  def binding_prediction_mail(pred, emails)
    @pred = pred

    mail ({to: emails, subject: "[XBindR]Binding Site Prediction Result, sid: #{pred.id}"})
  end
end