module DeleteCli
  def parse_delete(arr)
    del_hash = Hash[*arr.flatten(1)].each_value(&:strip!)
    @delete_query[:where] = del_hash['WHERE'].split(/=/).map(&:strip!)
    @delete_query[:where][1].gsub!(/'/, "")

    if del_hash['DELETE FROM'] == 'players'
      @delete_query[:from] = 'nba_players.csv'
    elsif del_hash['DELETE FROM'] == 'player_data'
      @delete_query[:from] = 'nba_player_data.csv'
    end
  end

  def run_delete
    @request = @request.delete
    @request = @request.from(@delete_query[:from])
    @request = @request.where(*@delete_query[:where])
    puts @request.run
  end
end