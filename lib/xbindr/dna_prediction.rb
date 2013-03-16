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

		attr_accessor :res_arr, :res_status, :runtimestamp
		attr_accessor :pssm_label

		def initialize(res_arr)
			self.res_arr = res_arr
			self.runtimestamp = Time.now.strftime "pssm_%Y%m%d%H%M%S%L"
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
				self.runtimestamp
				)
			Open3.popen3(
				"#{Settings.bin_dir}/blastpgp -j 3 -h 0.001 -d #{Settings.nr_file} -Q #{pssm_filename} -F C") do 
				|stdin, stdout, stderr|
				stdin.write self.res_arr
				stdin.close_write
				align = stdout.read.strip
			end
			p = open(pssm_filename).read.strip
			File.delete(pssm_filename)
			pssm = p.split("\n").map { |l| l.strip.split(" ")[0..21] }
			self.pssm_label = pssm[1]
			pssm = pssm[2..-7]
			return align, pssm
		end

		def norm_pssm pssm
			n_pssm = pssm.map do |l|
				[
					l[1],
					l[2..-1].map do |i|
						i = i.to_i
						1/(1+2.7182**(-i))
					end
				]
			end
		end

		def cal_pssmpp npssm
			npssm.map do |t, line|
				shu_sum   = 0
				pka_sum   = 0
				quan_sum  = 0
				bal_sum   = 0
				power_sum = 0
				wie_sum   = 0
				line.each_with_index do |item, index|
					shu_sum   += item * Const::SHU[pssm_label[index]]
					pka_sum   += item * Const::PKA[pssm_label[index]]
					quan_sum  += item * Const::QUAN[pssm_label[index]]
					bal_sum   += item * Const::BAL[pssm_label[index]]
					power_sum += item * Const::POWER[pssm_label[index]]
					wie_sum   += item * Const::WIE[pssm_label[index]]
				end
				[t, [shu_sum, pka_sum, quan_sum, bal_sum, power_sum, wie_sum]]
			end
		end

		def exec_runpsipred
			runpsipred_filename = File.join(
				Settings.tmp_root,
				self.runtimestamp
				)
			File.open(runpsipred_filename, "w") do |file|
				file.write(">#{runpsipred_filename}\n")
				file.write(self.res_arr.join(""))
			end
			Open3.popen3(
				"#{Settings.bin_dir}/runpsipred #{runpsipred_filename}") do
				|stdin, stdout, stderr|
				stdin.close_write
				out = stdout.read
			end
			second = File.read("#{runpsipred_filename}.ss2")
			File.delete("#{runpsipred_filename}.ss2")
			File.delete(runpsipred_filename)
		end
	end
end
