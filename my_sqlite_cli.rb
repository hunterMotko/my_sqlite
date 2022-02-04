require 'readline'
require_relative 'my_sqlite_request'
%w[print select insert update delete].each { |f| require_relative "cli_helpers/#{f}" }

class MySqliteQueryCli
  include SelectCli
  include InsertCli
  include UpdateCli
  include DeleteCli
  include Print

  def initialize
    @request = MySqliteRequest.new
    @action = nil
    @select_query = {}
    @insert_query = {}
    @update_query = {}
    @delete_query = {}
  end

  def reset
    @request = MySqliteRequest.new
    @action = nil
    @select_query = {}
    @insert_query = {}
    @update_query = {}
    @delete_query = {}
  end

  def parse(buf)
    parts = buf.split(/(SELECT|INSERT INTO|UPDATE|DELETE FROM|FROM|WHERE|JOIN|ON|SET|VALUES|ORDER BY|;)/)

    case parts[1].split.first
    when 'SELECT'
      @action = :select
      parse_select(parts[1..-2])
    when 'INSERT'
      @action = :insert
      parse_insert(parts[1..-2])
    when 'UPDATE'
      @action = :update
      parse_update(parts[1..-2])
    when 'DELETE'
      @action = :delete
      parse_delete(parts[1..-2])
    end
  end

  def check_action(buf)
    parse(buf)

    case @action
    when :select
      if !@select_query['SELECT'] && !@select_query['FROM']
        puts 'Sorry that query is incomplete'
      else
        run_select
      end
    when :insert
      run_insert
    when :update
      run_update
    when :delete
      run_delete
    end
    reset
  end

  def run
    begin
      while buf = Readline.readline("> ", true)
        buf.strip!
        if buf == 'quit'
          exit
        elsif !buf.end_with? ';'
          puts "You need to end a query with a semicolon!"
        else
          check_action(buf)
        end
      end
    rescue Interrupt
      puts "\n--Goodbye--\n"
    end
  end
end

cli = MySqliteQueryCli.new
cli.run