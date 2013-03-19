require 'open3'
require 'const'

module XbindR
	class DNAPrediction
		class self
			def do_predict res_seq
				p = DNAPrediction.new res_seq
				p.predict_chain!
				return p.res_status
			end
		end

		attr_accessor :res_seq, :res_status
		attr_accessor :runtimestamp, :runtime_root, :fn_root
		attr_accessor :seq_fn, :pssm_assic_fn, :pssm_chk_fn, :psipass2_fn, :rfmat_fn
		attr_accessor :pssmpp, :seconary, :sixenc

		def initialize(res_seq)
			self.res_seq = res_seq
			self.runtimestamp = Time.now.strftime "pssm_%Y%m%d%H%M%S%L"
			self.runtime_root = File.join(Settings.tmp_dir, self.runtimestamp)
			Dir.mkdir(self.runtime_root, 0755)
			self.fn_root =  File.join(self.runtime_root, 'seq')
			self.seq_fn = "#{self.fn_root}.fasta"
			File.open(self.seq_fn, "w") do |f|
				f.write ">#{self.runtimestamp}\n"
				f.write self.res_seq
			end
			self.pssm_assic_fn = "#{self.fn_root}.cqa"
			self.pssm_chk_fn = "#{self.fn_root}.chk"
		end

		def predict_chain!
			self.exec_blastpgp
			pssm_label, pssm = self.gen_pssm
			npssm = self.norm_pssm pssm
			pssmpp = self.gen_pssmpp npssm, pssm_label
			self.exec_psipred
			seconary = self.gen_seconary
			sixenc = self.gen_sixencode
			self.build_rfmat
			self.exec_rf
			self.gen_result
			self.clean_tmp
		end

		protected

		def exec_blastpgp
			cmd_str = "#{Settings.bin_dir}/blastpgp -b 0 -j 3\
			-h 0.001 -d #{Settings.dbname} -i #{self.seq_fn}\
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
				l[2..-1].map do |i|
					i = i.to_i
					1/(1+2.7182**(-i))
				end
			end
		end

		def gen_pssmpp npssm, pssm_label
			pssmpp = npssm.map do |line|
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
				[shu_sum, pka_sum, quan_sum, bal_sum, power_sum, wie_sum]
			end
			return pssmpp
		end

		def exec_psipred
			open("#{self.fn_root}.pn", "w") { |io| io.write(self.pssm_chk_fn) }
			open("#{self.fn_root}.sn", "w") { |io| io.write(self.seq_fn) }
			cmd_str = "#{Settings.bin_dir}/makemat -P #{File.join(self.runtime_root, 'seq')}"
			cmd = cmd_str.split(' ')
			output, status = Open3.capture2(cmd)
			raise "Failed to exec makemat" if status != 0
			datadir = File.join(Settings.data_dir, "psipred")
			cmd_str = "#{Settings.bin_dir}/psipred #{self.fn_root}.mtx \
			#{datadir}/weights.dat #{datadir}/weights.dat2 \
			#{datadir}/weights.dat3"
			cmd = cmd_str.split(' ')
			output, status = Open3.capture2(cmd)
			raise "Failed to exec psipred" if status != 0
			open("#{self.fn_root}.ss", "w") { |io| io.write output }
			self.psipass2_fn = "#{self.fn_root}.ss2"
			cmd_str = "#{Settings.bin_dir}/psipass2 #{datadir}/weights_p2.dat \
			1 1.0 1.0 #{self.psipass2_fn} #{self.fn_root}.ss"
			cmd = cmd_str.split(' ')
			output, status = Open3.capture2(cmd)
			raise "Failed to exec psipass2" if status != 0
			open("#{self.fn_root}.horiz", "w") { |io| io.write output }
		end

		def gen_seconary
			ss = open(self.psipass2_fn).read.strip
			ss_strlst = ss.split("\n").map { |l| l.strip.split(" ")[2] }
			ssm = ss_strlst.map do |e|
				case e
				when "H"
					[0,0,1]
				when "E"
					[0,1,0]
				when "C"
					[1,0,0]
				else
					[1,0,0]
				end
			end
			return ssm
		end

		def gen_sixencode
			sixenc = []
			self.res_seq.each_char do |c|
				sixenc << Const::SIXENC[c]
			end
			return sixenc
		end

		def build_rfmat
			f = File.open(self.rfmat_fn, 'w')
			(self.res_seq.length - 11 + 1).times.each do |idx|
				f.write self.pssmpp[idx...11].map { |l| l.join "\t" }.join "\t"
				f.write "\t"
				f.write self.seconary[idx...11].map { |l| l.join "\t" }.join "\t"
				f.write "\t"
				f.write self.sixenc[idx...11].join "\t"
				f.write "\n"
			end
			f.close
		end

		def exec_rf
			cmd_str = "Rscript #{Settings.bin_dir}/RF.R #{self.rfmat_fn}"
			cmd = cmd_str.split(' ')
			output, status = Open3.capture2(cmd, :chdir => Settings.data_dir)
			raise "Failed to exec rand forest of R" if status != 0
		end

		def gen_result
			
		end

		def clean_tmp
			
		end

	end
end
