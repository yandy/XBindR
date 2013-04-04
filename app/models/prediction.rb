require 'xbindr'

class Prediction < ActiveRecord::Base

	attr_accessor :email

	attr_accessible :res_seq, :nt, :cutoff, :email

	validates :res_seq,
	:length => {
		:minimum => 11
		},
	:format => {
		:with    => Regexp.new(Settings.protein_seq_regexp),
		:message => 'Invalid protein sequence'
	}

	validates :cutoff, :inclusion => { :in => ["3.5", "6.0"]}

	validates :nt, :inclusion => { :in => [0, 1] }

	validates :email, :format => {
		:with => Regexp.new(Settings.email_regexp)
	}

	def do_predict!
		case nt
		when 0
			self.res_status = XbindR::DNAPrediction.do_predict res_seq
		when 1
			self.res_status = XbindR::RNAPrediction.do_predict res_seq, cutoff.to_f
		end
		self.save
	end
end
