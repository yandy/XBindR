module XbindR
  class RNAPrediction

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
      self.gen_pssmpp
      self.gen_seconary
      self.gen_sixencode
      self.gen_rfmat
      self.gen_vote
      self.gen_result
      self.clean_tmp
    end

  end
end
