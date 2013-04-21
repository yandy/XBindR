module XbindR
  class DNAPrediction < Prediction

    def self.do_predict res_seq
      p = DNAPrediction.new res_seq
      p.predict_chain!
      return p
    end

    def initialize(res_seq)
      self.res_seq = res_seq
      self.cutoff = 3.5
      self.winlength = WIN_LEN_35
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
      self.gen_pssmpp
      self.gen_seconary
      self.gen_sixencode
      self.gen_rfmat
      self.gen_vote
      self.gen_result
      self.clean_tmp
    end

    protected

    def gen_rfmat
      f = File.open(self.rfmat_fn, 'w')
      (self.res_seq.length - self.winlength + 1).times.each do |idx|
        offset = idx + self.winlength - 1
        f.write self.pssmpp[idx..offset].map { |l| l.join "\t" }.join "\t"
        f.write "\t"
        f.write self.seconary[idx..offset].map { |l| l.join "\t" }.join "\t"
        f.write "\t"
        f.write self.sixenc[idx..offset].join "\t"
        f.write "\n"
      end
      f.close
    end

    def gen_result
      vcutoff = 0.845
      res_status = ""
      res_ri = []
      self.vote.each do |s, r|
        res_status << ((s.to_f > vcutoff) ? "-" : "+")
        ri = (1 - s.to_f - 0.2).abs
        res_ri << ((ri < 0.18) ? (ri * 56).to_i : 10)
      end
      self.res_status = ('-' * (self.winlength/2)) + res_status + ('-' * (self.winlength/2))
      self.res_ri = ([-1] * (self.winlength/2)) + res_ri + ([-1] * (self.winlength/2))
    end

  end
end
