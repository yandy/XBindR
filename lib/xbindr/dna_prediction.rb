require 'open3'

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
			npssm = self.pssm_normalization pssm
		end

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
			pssm = open(pssm_filename).read.strip
			return align, pssm
		end

		def pssm_normalization pssm
			rlines = pssm.split "\n"
			rlines = rlines.map { |l| l.strip.split(" ")[2..21] }
			rlines = rlines[2..-7]
			n_pssm = rlines.map do |l|
				l.map do |i|
					i = i.to_i
					1/(1+2.7182**(-i))
				end
			end
		end
	end
end
