module UpdateCli
  def parse_update(arr)
    update_hash = Hash[*arr.flatten(1)].each_value(&:strip!)

    if update_hash['UPDATE'] == 'players'
      @update_query[:update] = 'nba_players.csv'
    elsif update_hash['UPDATE'] == 'player_data'
      @update_query[:update] = 'nba_player_data.csv'
    end

    @update_query[:set] = Hash[*update_hash['SET'].split(/=|,(?=(?:(?:[^']*'){2})*[^']*$)/).map(&:strip!)]
    @update_query[:where] = update_hash['WHERE'].split(/=/).map(&:strip!)
    @update_query[:set].each { |_, val| val.gsub!(/'/, '') }
    @update_query[:where][1].gsub!(/'/, '')
  end

  def run_update
    unless @update_query.empty?
      @request = @request.update(@update_query[:update])
      @request = @request.set(@update_query[:set])
      @request = @request.where(*@update_query[:where])
      p @request.run
    end
  end
end