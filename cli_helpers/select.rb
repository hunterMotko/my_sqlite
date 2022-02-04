require_relative 'print'
module SelectCli
  def parse_select(arr)
    sel_hash = Hash[*arr.flatten(1)]

    sel_hash.each_value(&:strip!)

    sel_hash['SELECT'] = sel_hash['SELECT'].split(',').map(&:strip) unless sel_hash['SELECT'].include?('*')

    if sel_hash['WHERE']
      if sel_hash['WHERE'].include?('AND')
      sel_hash['WHERE'] = sel_hash['WHERE'].split(/AND/).map { |i| i.split(/=/).map(&:strip)}
      else
        sel_hash['WHERE'] = sel_hash['WHERE'].split(/=/).map(&:strip)
      end
    end

    sel_hash['ON'] = sel_hash['ON'].split(/=/).map(&:strip) if sel_hash['ON']

    sel_hash['ORDER BY'] = sel_hash['ORDER BY'].split if sel_hash['ORDER BY']

    @select_query = sel_hash
  end

  def run_select
    if @select_query['FROM'] == 'players'
      @request = @request.from('nba_players.csv')
    elsif @select_query['FROM'] == 'player_data'
      @request = @request.from('nba_player_data.csv')
    end
    @request = @request.select(@select_query['SELECT'])
    if @select_query['WHERE']
      if @select_query['WHERE'].first.is_a?(Array)
        col1, critea1 = @select_query['WHERE'][0]
        col2, critea2 = @select_query['WHERE'][1]

        @request = @request.where(col1, critea1[1..-2])
        @request = @request.where(col2, critea2[1..-2])
      else
         col, critea = @select_query['WHERE']
        @request = @request.where(col, critea[1..-2])
      end
    end
    if @select_query['JOIN'] && @select_query['ON']
      if @select_query['JOIN'] == 'players'
        @request = @request.join('nba_players.csv', *@select_query['ON'])
      elsif @select_query['JOIN'] == 'player_data'
        @request = @request.join('nba_player_data.csv', *@select_query['ON'])
      end
    end
    if @select_query['ORDER BY']
      @request = @request.order(*@select_query['ORDER BY'])
    end
    print_table(@request.run)
  end
end