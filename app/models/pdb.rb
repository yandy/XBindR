require 'bio'
class Pdb < ActiveRecord::Base
  attr_accessor :biopdb

  attr_accessible :description, :entry_id, :biopdb, :pdbfile, :ct
  has_many :chains, :dependent => :destroy

  DNA_PATH = File.join(Settings.data_dir, 'pdb', 'dna')
  RNA_PATH = File.join(Settings.data_dir, 'pdb', 'rna')

  def self.build_pdb_db
    Dir.foreach(DNA_PATH) do |f|
      next if File.directory? File.join(DNA_PATH, f)
      entry_id = f.downcase.chomp('.pdb')
      next if !(entry_id =~ /^\w+$/) || Pdb.where(entry_id: entry_id).count > 0
      pdbfile = File.join(DNA_PATH, f)
      biopdb = Bio::FlatFile.open(Bio::PDB, pdbfile).entries.first
      next if biopdb.nil?
      pdb = Pdb.create(entry_id: entry_id, biopdb: biopdb, pdbfile: pdbfile, ct: 'dna')
      protein_chains = []
      dna_chains = []
      pdb.biopdb.each_chain do |chain|
        sample_res = chain.residues.first
        next if sample_res.nil?
        if sample_res.resName.length == 3
          protein_chains << chain
          #puts "#{chain.id} start with #{sample_res.resName} in Protein"
        else
          dna_chains << chain
          #puts "#{chain.id} start with #{sample_res.resName} in DNA"
        end
      end
      #puts protein_chains.size
      #puts dna_chains.size
      dna_atoms = []
      dna_chains.each do |ch|
        dna_atoms.concat ch.atoms
      end
      protein_chains.each do |ch|
        #puts "Start creating chain #{ch.id}"
        resdist = []
        ch.residues.each do |res|
          min_dist = 1000
          res.atoms.each do |pa|
            dna_atoms.each do |da|
              dist = pa.xyz.distance da.xyz
              min_dist = dist if dist < min_dist
            end
          end
          resName = "%s%s" % [res.resName[0].upcase, res.resName[1..-1].downcase]
          #puts resName, min_dist
          resdist << [Bio::AminoAcid.three2one(resName), resName, min_dist]
        end
        pdb.chains.create(name: ch.id.downcase, resdist: resdist)
        #puts "Finish #{ch.id}"
      end
    end
    Dir.foreach(RNA_PATH) do |f|
      next if File.directory? File.join(RNA_PATH, f)
      entry_id = f.downcase.chomp('.pdb')
      next if !(entry_id =~ /^\w+$/) || Pdb.where(entry_id: entry_id).count > 0
      pdbfile = File.join(RNA_PATH, f)
      biopdb = Bio::FlatFile.open(Bio::PDB, pdbfile).entries.first
      next if biopdb.nil?
      pdb = Pdb.create(entry_id: entry_id, biopdb: biopdb, pdbfile: pdbfile, ct: 'rna')
      protein_chains = []
      rna_chains = []
      pdb.biopdb.each_chain do |chain|
        sample_res = chain.residues.first
        next if sample_res.nil?
        if sample_res.resName.length == 3
          protein_chains << chain
          #puts "#{chain.id} start with #{sample_res.resName} in Protein"
        else
          rna_chains << chain
          #puts "#{chain.id} start with #{sample_res.resName} in RNA"
        end
      end
      #puts protein_chains.size
      #puts rna_chains.size
      rna_atoms = []
      rna_chains.each do |ch|
        rna_atoms.concat ch.atoms
      end
      protein_chains.each do |ch|
        #puts "Start creating chain #{ch.id}"
        resdist = []
        ch.residues.each do |res|
          min_dist = 1000
          res.atoms.each do |pa|
            rna_atoms.each do |da|
              dist = pa.xyz.distance da.xyz
              min_dist = dist if dist < min_dist
            end
          end
          resName = "%s%s" % [res.resName[0].upcase, res.resName[1..-1].downcase]
          #puts resName, min_dist
          resdist << [Bio::AminoAcid.three2one(resName), resName, min_dist]
        end
        pdb.chains.create(name: ch.id.downcase, resdist: resdist)
        #puts "Finish #{ch.id}"
      end
    end
  end

end
