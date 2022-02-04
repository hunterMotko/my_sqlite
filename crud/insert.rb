module Insert
  def insert(table_name)
    @table_name = table_name
    self._setTypeOfResquest(:insert)
    self
  end

  def values(data)
    if (@request_type == :insert)
      if @table_name == 'nba_players.csv'
        id = File.readlines(@table_name).size - 1
        @insert_attr = {'id'=>id}.merge(data)
      else
        @insert_attr = data
      end
    else
      raise 'Wrong type of request to call values'
    end
    self
  end

  def print_insert_type
    puts "Insert Attributes #{@insert_attr}"
  end

  def _run_insert
    File.open(@table_name, 'a') do |f|
      f.puts @insert_attr.values.join(',')
    end
    'Insert Successful'
  end

end