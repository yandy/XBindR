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
			pssm_out = self.passm
		end

		def pssm
			out = ""
			Open3.popen3(
				"blastpgp -j 3 -h 0.001 -d #{Settings.nr_file} -Q $dir/a.cqa -F C") do 
				|stdin, stdout, stderr|
				stdin.write self.res_arr
				stdin.close_write
				out = stdout.read
			end
			return out
		end
	end
end
