module Print
  def print_table(res)
    data = res.map(&:values)
    headers = res.map(&:keys).uniq[0]
    col_width = []
    headers.each { |header| header.nil? ? col_width << 5 : col_width << header.size}

    data.each do |row|
      row.each_with_index do |val, i|
        if val.nil?
          col_width[i] = 6 if col_width[i] < 6
        elsif col_width[i] < val.size
          col_width[i] = val.size + 1
        end
      end
    end
    width = col_width.reduce(:+)
    print ' '+'-'*(width + 12 )+ "\n"
    print_row(headers, col_width)
    print ' '+'-'*(width + 12 )+ "\n"
    data.each {|row| print_row(row, col_width)}
    print ' '+'-'*(width + 12 )+ "\n"

    puts "(#{data.size} rows)"
  end

  def print_row(row, col_width)
    row.each_with_index do |val, i|
      print "|"
      if val.nil?
        print '     '
        print " "*(col_width[i]-5)
      else
        print val
        res = (col_width[i]-val.length)
        res = 1 if res < 0
        print " "* res
      end
    end
    print "|\n"
  end
end