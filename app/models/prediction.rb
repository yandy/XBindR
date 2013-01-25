class Prediction < ActiveRecord::Base

	attr_accessor :email

	serialize :res_arr
	serialize :res_status

	attr_accessible :res_arr, :nt, :email

	validates :res_arr,
	:length => {
		:minimum => 11
		},
	:format => {
		:with    => Regexp.new(Settings.protein_seq_regexp),
		:message => 'Invalid protein sequence'
	}

	validates :nt, :inclusion => { :in => [0, 1] }

	validates :email, :format => {
		:with => Regexp.new(Settings.email_regexp)
	}

	def do_predict!
		# pass
	end
end
