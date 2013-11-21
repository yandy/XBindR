require 'xbindr'

class Prediction < ActiveRecord::Base

	belongs_to :pdb

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

	def from_pdb?
		pdb_flag
	end

	def default_values
		self.email ||= "yourname@example.com"
	end

	def do_predict!
		case nt
		when 0
			p = XbindR::DNAPrediction.do_predict res_seq
			self.res_status = p.res_status
			self.res_ri = p.res_ri
		when 1
			p = XbindR::RNAPrediction.do_predict res_seq, cutoff.to_f
			self.res_status = p.res_status
			self.res_ri = p.res_ri
		end
		self.save
	end
end
