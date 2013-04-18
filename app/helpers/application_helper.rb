module ApplicationHelper
  def format_seq_tbl res_hash
    tbl_out = ""
    res_seq = res_hash[:res_seq]
    res_status = res_hash[:res_status]
    res_ri = res_hash[:res_ri]
    idx_group = (0..(res_seq.length-1)).group_by {|i| i/20}
    idx_group.each do |k, idx_arr|
      tbl_out << "<table class=\"table-bordered table-seq\">"
      tbl_out << "<thead><tr>"
      idx_arr.each do |idx|
        cls = ((res_status[idx] == "+") ? ' class="pos_seq"' : '')
        tbl_out << "<th#{cls}>#{idx}</th>"
      end
      tbl_out << "</tr></thead>"
      tbl_out << "<tbody><tr>"
      idx_arr.each do |idx|
        cls = ((res_status[idx] == "+") ? ' class="pos_seq"' : '')
        tbl_out << "<td#{cls}>#{res_seq[idx]}</td>"
      end
      tbl_out << "</tr><tr>"
      idx_arr.each do |idx|
        cls = ((res_status[idx] == "+") ? ' class="pos_seq"' : '')
        tbl_out << "<td#{cls}>#{res_status[idx]}</td>"
      end
      unless res_ri.nil?
        tbl_out << "</tr><tr>"
        idx_arr.each do |idx|
          cls = ((res_status[idx] == "+") ? ' class="pos_seq"' : '')
          ri_out = ((res_ri[idx] == -1) ? "-" : res_ri[idx].to_s)
          tbl_out << "<td#{cls}>#{ri_out}</td>"
        end
      end
      tbl_out << "</tr></tbody>"
      tbl_out << "</table>"
    end
    tbl_out.html_safe
  end
end
