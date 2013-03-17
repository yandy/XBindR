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
		attr_accessor :runtimestamp, :runtime_root, :input_fn, :pssm_assic_fn, :pssm_chk_fn

		def initialize(res_arr)
			self.res_arr = res_arr
			self.runtimestamp = Time.now.strftime "pssm_%Y%m%d%H%M%S%L"
			self.runtime_root = File.join(Settings.tmp_dir, self.runtime_root)
			Dir.mkdir(self.runtime_root, 0755)
			self.input_fn = File.join(self.runtime_root, 'input.fasta')
			File.open(self.input_fn, "w") do |f|
				f.write ">#{self.runtimestamp}\n"
				f.write self.res_arr
			end
		end

		def predict_chain!
			self.exec_blastpgp
			pssm_label, pssm = self.gen_pssm
			npssm = self.norm_pssm pssm
			pssmpp = self.gen_pssmpp npssm, pssm_label
			self.exec_psipred
			seconary = self.gen_seconary
			sixenc = self.gen_sixencode
			#RF
			self.clean_tmp
		end

		protected

		def exec_blastpgp
			cmd_str = "#{Settings.bin_dir}/blastpgp -b 0 -j 3\
			-h 0.001 -d #{Settings.dbname} -i #{self.input_fn}\
			-Q #{self.pssm_assic_fn} -C #{self.pssm_chk_fn}"
			cmd = cmd_str.split(' ')
			output, status = Open3.capture2(cmd)
			raise "Failed to exec blastpgp" if status != 0
		end

		def gen_pssm
			p = open(self.pssm_assic_fn).read.strip
			pssm = p.split("\n").map { |l| l.strip.split(" ")[0..21] }
			pssm_label = pssm[1]
			pssm = pssm[2..-7]
			return pssm_label, pssm
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

		def gen_pssmpp npssm, pssm_label
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

		def exec_psipred
			
		end

		def gen_seconary
			
		end

		def gen_sixencode
			
		end

		def clean_tmp
			
		end

	end
end
