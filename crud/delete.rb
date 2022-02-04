module Delete
  def delete
    self._setTypeOfResquest(:delete)
    self
  end

  def print_delete_type
    puts "Where Attributes #{@where_params}"
  end

  def _run_delete
    csv = CSV.parse(File.open(@table_name), headers: true)

    csv.delete_if { |row| row[@where_params[0][0]] == @where_params[0][1] }

    File.open(@table_name, 'w') do |f|
      f.write(csv)
    end
    'Delete Successful'
  end
end