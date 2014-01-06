module XbindR
  class RNAPrediction < Prediction

    def self.do_predict res_seq, cutoff
      p = RNAPrediction.new res_seq, cutoff
      p.predict_chain!
      return p
    end

    def initialize(res_seq, cutoff)
      self.res_seq = res_seq
      self.cutoff = cutoff
      self.winlength = ((cutoff == 3.5) ? WIN_LEN_35 : WIN_LEN_60)
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
      self.psipass2_fn = "#{self.fn_root}.ss2"
      self.rfmat_fn = "#{self.fn_root}.mat"
    end

    def predict_chain!
      self.gen_npssm
      self.gen_pssmpp if self.cutoff == 3.5
      self.gen_seconary
      self.gen_rfmat
      self.gen_vote
      self.gen_result
      self.clean_tmp
    end

    protected

    def rdata
      @rdata ||= ((self.cutoff == 3.5) ? "RNA-RFDATA3.5" : "RNA-RFDATA6.0")
    end

    def current_pssm
      @current_pssm ||= ((self.cutoff == 3.5) ? self.pssmpp : self.npssm )
    end

    def gen_rfmat
      f = File.open(self.rfmat_fn, 'w')
      (self.res_seq.length - self.winlength + 1).times.each do |idx|
        offset = idx + self.winlength - 1
        f.write self.current_pssm[idx..offset].map { |l| l.join "\t" }.join "\t"
        f.write "\t"
        f.write self.gen_pcc(self.res_seq[idx..offset]).join "\t"
        f.write "\t"
        f.write self.gen_hc(self.res_seq[idx..offset]).join "\t"
        f.write "\t"
        f.write self.seconary[idx..offset].map { |l| l.join "\t" }.join "\t"
        f.write "\n"
      end
      f.close
    end

    def gen_result
      vcutoff = ((self.cutoff == 3.5) ? 0.6 : 0.72)
      res_status = ""
      res_ri = []
      self.vote.each do |s, r|
        res_status << ((s.to_f > vcutoff) ? "-" : "+")
        ri = (1 - s.to_f - 0.25).abs
        res_ri << ((ri < 0.18) ? (ri * 56).to_i : 10)
      end
      self.res_status = ('-' * (self.winlength/2)) + res_status + ('-' * (self.winlength/2))
      self.res_ri = ([-1] * (self.winlength/2)) + res_ri + ([-1] * (self.winlength/2))
    end

  end
end
