module Update
  def update(table_name)
    @table_name = table_name
    self._setTypeOfResquest(:update)
    self
  end

  def set(data)
    if (@request_type == :update)
      @update_attr = data
    else
      raise 'Wrong type of request to call values'
    end
    self
  end

  def print_update_type
    puts "Update Attribute #{@update_attr}"
    puts "Where Attributes #{@where_params}"
  end

  def _run_update
    res = []
    CSV.foreach(@table_name, headers: true) do |row|
      hash = row.to_h
      if hash[@where_params[0][0]] == @where_params[0][1]
        @update_attr.each {|k,v| hash[k] = v}
      end
      if res.length == 0
        res << hash.keys
        res << hash.values
      else
        res << hash.values
      end
    end

    str = CSV.generate do |csv|
      res.each do |row|
        csv << row
      end
    end

    File.open(@table_name, 'w') do |f|
      f.write(str)
    end
    'Update Success'
  end
end