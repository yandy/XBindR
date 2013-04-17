require 'xbindr'

class Prediction < ActiveRecord::Base

	after_initialize :default_values

	TYPE_DNA = 0
	TYPE_RNA = 1

	attr_accessor :email

	attr_accessible :res_seq, :nt, :cutoff, :email

	serialize :res_ri

	validates :res_seq,
	:format => {
		:with    => Regexp.new(Settings.protein_seq_regexp),
		:message => 'Invalid protein sequence'
	}

	validates :cutoff, :inclusion => { :in => [3.5, 6.0]}

	validates :nt, :inclusion => { :in => [TYPE_DNA, TYPE_RNA] }

	validates :email, :format => {
		:with => Regexp.new(Settings.email_regexp)
	}

	def default_values
		self.email ||= "yourname@example.com"
	end

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
