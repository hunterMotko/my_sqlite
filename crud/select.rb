
module Select
  def select(columns)
    if(columns.is_a?(Array))
      @select_columns += columns.collect {|x| x.to_s}
    else
      @select_columns << columns.to_s
    end
    self._setTypeOfResquest(:select)
    self
  end


  def join(filename_db_b, column_on_db_a, column_on_db_b)
    @join_table_name = filename_db_b
    @join_columns = [column_on_db_a, column_on_db_b]
    self
  end

  def order(column_name, order)
    @order_column = column_name
    if order == 'DESC'
      @order = :desc
    else
      @order = :asc
    end
    self
  end

  def print_select_type
    puts "Select Attributes #{@select_columns}"
    puts "Where Attributes #{@where_params}"
  end

  def filter_where(row, res)
    if @where_params.length == 2
      f,s = @where_params
      check_wildcard(row, res) if !row[f[0]].nil? && !row[s[0]].nil? && row[f[0]].include?(f[1]) && row[s[0]].include?(s[1])
    elsif !row[@where_params[0][0]].nil? && row[@where_params[0][0]].include?(@where_params[0][1])
      check_wildcard(row, res)
    end
  end

  def check_wildcard(row, res)
    if @select_columns.include?('*')
      res << row.to_hash
    else
      res << row.to_hash.slice(*@select_columns)
    end
  end

  def check_order(res)
    if @order == :desc && @order_column
      res.sort! { |a, b| b[@order_column] <=> a[@order_column] }
    elsif @order == :asc && @order_column
      res.sort! { |a, b| a[@order_column] <=> b[@order_column] }
    end
    res
  end

  def run_join(row, join_row, res)
    col_a, col_b = @join_columns
    if row[col_a] == join_row[col_b]
      row = row.to_h.merge!(join_row.to_h)
      if @where_params.empty?
        check_wildcard(row, res)
      else
        filter_where(row, res)
      end
    end
    res
  end

  def _run_select
    res = []
    csv = CSV.parse(File.read(@table_name), headers: true)
    csv.each do |row|
      if @join_table_name && @join_columns
        join_csv = CSV.parse(File.read(@join_table_name), headers: true)
        join_csv.each do |j_row|
          run_join(row, j_row, res)
        end
      elsif @where_params.empty?
        check_wildcard(row, res)
      else
        filter_where(row, res)
      end
    end
    check_order(res)
    res
  end
end