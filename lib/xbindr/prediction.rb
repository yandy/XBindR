require 'open3'

module XbindR
  class Prediction

    WIN_LEN_35 = 11
    WIN_LEN_60 = 21

    attr_accessor :res_seq, :cutoff, :res_status, :res_ri
    attr_accessor :runtimestamp, :runtime_root, :fn_root, :winlength
    attr_accessor :seq_fn, :pssm_assic_fn, :pssm_chk_fn, :psipass2_fn, :rfmat_fn
    attr_accessor :npssm, :pssmpp, :seconary, :sixenc, :ppc, :vote

    protected

    def exec_blastpgp
      return if !!@blasted
      cmd = "#{Settings.bin_dir}/blastpgp -b 0 -j 3 \
          -h 0.001 -d #{Settings.dbname} -i #{self.seq_fn} \
          -Q #{self.pssm_assic_fn} -C #{self.pssm_chk_fn}"
      output, status = Open3.capture2(cmd, :chdir => Settings.cbi_root)
      raise "Failed to exec blastpgp" if status != 0
      @blasted = true
    end

    def gen_npssm
      self.exec_blastpgp
      p = open(self.pssm_assic_fn).read.strip
      pssm = p.split("\n").map { |l| l.strip.split(" ")[0..21] }
      self.pssm_label = pssm[1]
      pssm = pssm[2..-7]
      self.npssm = pssm.map do |l|
        l[2..-1].map do |i|
          i = i.to_i
          1/(1+2.7182**(-i))
        end
      end
    end

    def gen_pssmpp
      self.pssmpp = self.npssm.map do |line|
        shu_sum   = 0
        pka_sum   = 0
        quan_sum  = 0
        bal_sum   = 0
        power_sum = 0
        wie_sum   = 0
        line.each_with_index do |item, index|
          shu_sum   += item * XConst::SHU[self.pssm_label[index]]
          pka_sum   += item * XConst::PKA[self.pssm_label[index]]
          quan_sum  += item * XConst::QUAN[self.pssm_label[index]]
          bal_sum   += item * XConst::BAL[self.pssm_label[index]]
          power_sum += item * XConst::POWER[self.pssm_label[index]]
          wie_sum   += item * XConst::WIE[self.pssm_label[index]]
        end
        [shu_sum, pka_sum, quan_sum, bal_sum, power_sum, wie_sum]
      end
    end

    def exec_psipred
      return if !!@psipreded
      open("#{self.fn_root}.pn", "w") { |io| io.write("seq.chk") }
      open("#{self.fn_root}.sn", "w") { |io| io.write("seq.fasta") }
      cmd = "#{Settings.bin_dir}/makemat -P #{self.fn_root}"
      output, status = Open3.capture2(cmd, :chdir => Settings.cbi_root)
      raise "Failed to exec makemat" if status != 0
      datadir = File.join(Settings.data_dir, "psipred")
      cmd = "#{Settings.bin_dir}/psipred #{self.fn_root}.mtx \
      #{datadir}/weights.dat #{datadir}/weights.dat2 \
      #{datadir}/weights.dat3"
      output, status = Open3.capture2(cmd, :chdir => Settings.cbi_root)
      raise "Failed to exec psipred" if status != 0
      open("#{self.fn_root}.ss", "w") { |io| io.write output }
      cmd = "#{Settings.bin_dir}/psipass2 #{datadir}/weights_p2.dat \
            1 1.0 1.0 #{self.psipass2_fn} #{self.fn_root}.ss"
      output, status = Open3.capture2(cmd)
      raise "Failed to exec psipass2" if status != 0
      open("#{self.fn_root}.horiz", "w") { |io| io.write output }
      @psipreded = true
    end

    def gen_seconary
      self.exec_psipred
      ss = open(self.psipass2_fn).read.strip
      ss_strlst = ss.split("\n")[2..-1].map { |l| l.strip.split(" ")[2] }
      self.seconary = ss_strlst.map do |e|
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
    end

    def gen_sixencode
      sixenc = []
      self.res_seq.each_char do |c|
        sixenc << XConst::SIXENC[c]
      end
      self.sixenc = sixenc
    end

    def gen_pcc
      pcc_seq = []
      ni = [0, 0, 0, 0]
      self.res_seq.each_char do |c|
        pcc_seq << XConst::PCC[c]
        ni[XConst::PCC[c]] += 1
      end
      #TODO
    end

    def gen_vote
      return if !!self.vote
      rbin = ((self.cutoff == 3.5) ? "RF.R" : "RF6.R")
      cmd = "Rscript #{Settings.bin_dir}/#{rbin} #{self.rfmat_fn} #{File.join(Settings.data_dir, "RFDATA3.5")}"
      vote, status = Open3.capture2(cmd, :chdir => Settings.cbi_root)
      raise "Failed to exec rand forest of R" if status != 0
      self.vote = vote.split("\n").map { |l| l.split("\t") }
    end

    def gen_rfmat
      raise "Not Implemented"
    end

    def gen_result
      raise "Not Implemented"
    end

    def clean_tmp
      FileUtils.rm_rf(self.runtime_root)
    end

  end
end
