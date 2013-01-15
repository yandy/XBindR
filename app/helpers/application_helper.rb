module ApplicationHelper
  def format_seq_tbl res_hash
    res_arr = res_hash[:res_arr]
    res_status = res_hash[:res_status]
    idx_group = (0..(res_arr.length-1)).group_by {|i| i/20}
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
        tbl_out << "<td#{cls}>#{res_arr[idx]}</td>"
      end
      tbl_out << "</tr><tr>"
      idx_arr.each do |idx|
        cls = ((res_status[idx] == "+") ? ' class="pos_seq"' : '')
        tbl_out << "<td#{cls}>#{res_status[idx]}</td>"
      end
      tbl_out << "</tr></tbody>"
      tbl_out << "</table>"
    end
    tbl_out.html_safe
  end
end
