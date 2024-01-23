# Constants for actions
SELECT = 'SELECT'
INSERT = 'INSERT'
UPDATE = 'UPDATE'
DELETE = 'DELETE'

# Constants for symbols
SELECT_SYM = :select
INSERT_SYM = :insert
UPDATE_SYM = :update
DELETE_SYM = :delete

# Class for query parts
class MySqliteQueryCli
  include SelectCli
  include InsertCli
  include UpdateCli
  include DeleteCli
  include Print

  def initialize
    reset
  end

  def reset
    @request = MySqliteRequest.new
    @action = nil
    @select_query = {}
    @insert_query = {}
    @update_query = {}
    @delete_query = {}
  end

  # Split the buffer and determine the action
  def parse(buf)
    parts = buf.split(/(#{SELECT}|#{INSERT} INTO|#{UPDATE}|#{DELETE} FROM|FROM|WHERE|JOIN|ON|SET|VALUES|ORDER BY|;)/)
    action_string = parts[1]&.split&.first
    determine_action(action_string, parts[1..-2]) if action_string
  end

  # Determine the action based on the action string
  def determine_action(action_string, parts)
    case action_string
    when SELECT
      @action = SELECT_SYM
      parse_select(parts)
    when INSERT
      @action = INSERT_SYM
      parse_insert(parts)
    when UPDATE
      @action = UPDATE_SYM
      parse_update(parts)
    when DELETE
      @action = DELETE_SYM
      parse_delete(parts)
    else
      puts "Invalid action: #{action_string}"
    end
  end

  def check_action(buf)
    parse(buf)
    case @action
    when SELECT_SYM
      if !@select_query[SELECT] && !@select_query['FROM']
        puts 'Sorry that query is incomplete'
      else
        run_select
      end
    when INSERT_SYM
      run_insert
    when UPDATE_SYM
      run_update
    when DELETE_SYM
      run_delete
    end
    reset
  end

  def run
    while buf = Readline.readline('> ', true)
      buf.strip!
      if buf == 'quit'
        break
      elsif !buf.end_with? ';'
        puts 'You need to end a query with a semicolon!'
      else
        check_action(buf)
      end
    end
  rescue Interrupt
    puts "\n--Goodbye--\n"
  end
end

cli = MySqliteQueryCli.new
cli.run
