require 'csv'
%w[select insert update delete].each { |f| require_relative "crud/#{f}" }

class MySqliteRequest
  include Select
  include Insert
  include Update
  include Delete

  def initialize
    @request_type = :none
    @select_columns = []
    @insert_attr = {}
    @update_attr = {}
    @where_params = []
    @table_name = nil
    @join_table_name = nil
    @join_columns = []
    @order = nil
    @order_column = ''
  end

  def from(table_name)
    @table_name = table_name
    self
  end

  def where(column_name, critera)
    @where_params << [column_name, critera]
    self
  end

  def run
    puts "Type Of Request #{@request_type}"
    puts "Table name #{@table_name}"
    if @request_type == :select
      print_select_type
      _run_select
    elsif @request_type == :insert
      print_insert_type
      _run_insert
    elsif @request_type == :update
      print_update_type
      _run_update
    elsif @request_type == :delete
      print_delete_type
      _run_delete
    end
  end

  def _setTypeOfResquest(new_type)
    if(@request_type == :none || @request_type == new_type)
      @request_type = new_type
    else
      raise "Invaild: type of request already set to #{@request_type} (new_type => #{new_type})"
    end
  end

end

# def main
# INSERT TEST CASES HERE
# end

# main
