require 'open3'
require 'const'

module XbindR
	class DNAPrediction
		class self
			def do_predict res_arr
				p = DNAPrediction.new res_arr
				p.predict_chain!
				return p.res_status
			end
		end

		attr_accessor :res_arr, :res_status

		def initialize(res_arr)
			self.res_arr = res_arr
		end

		def predict_chain!
			align, pssm= self.exec_blastpgp
			npssm = self.norm_pssm pssm
			pssmpp = self.cal_pssmpp npssm
		end

		protected

		def exec_blastpgp
			align = ""
			pssm_filename = File.join(
				Settings.tmp_root,
				Time.now.strftime "pssm_%Y%m%d%H%M%S%L"
				)
			Open3.popen3(
				"blastpgp -j 3 -h 0.001 -d #{Settings.nr_file} -Q #{pssm_filename} -F C") do 
				|stdin, stdout, stderr|
				stdin.write self.res_arr
				stdin.close_write
				align = stdout.read.strip
			end
			p = open(pssm_filename).read.strip
			pssm = p.split "\n".map { |l| l.strip.split(" ")[0..21] }
			pssm = pssm[2..-7]
			return align, pssm
		end

		def norm_pssm pssm
			n_pssm = pssm.map do |l|
				[
					l[0..1],
					l[2..-1].map do |i|
						i = i.to_i
						1/(1+2.7182**(-i))
					end
				]
			end
		end

		def cal_pssmpp npssm
		end
	end
end
