module InsertCli
  def parse_insert(arr)
    ins_hash = Hash[*arr.flatten(1)]
    ins_hash.each_value(&:strip!)
    insert_cols = []
    player_data_columns = ['name','year_start','year_end','position','height','weight','birth_date','college']
    players_columns = ['Player', 'height', 'weight', 'college', 'born', 'birth_city', 'birth_state']

    ins_hash['VALUES'] = ins_hash['VALUES'].split(/\(|,|\)/)[1..-1].map {|i| i.gsub(/'/, '')}

    if ins_hash['INSERT INTO'].length > 13
      ins_hash['INSERT INTO'], insert_cols = ins_hash['INSERT INTO'].split(/ \(|,|\)/).partition.with_index {|_,i| i == 0}
      ins_hash['INSERT INTO'] = ins_hash['INSERT INTO'].join
    end

    if ins_hash['INSERT INTO'] == 'player_data' && ins_hash['VALUES'].length == player_data_columns.length
      @insert_query[:values] = player_data_columns.zip(ins_hash['VALUES']).to_h
    elsif ins_hash['INSERT INTO'] == 'player_data' && !insert_cols.empty?
      @insert_query[:values] = Hash[player_data_columns.map { |i| [i, ''] }].merge(insert_cols.zip(ins_hash['VALUES']).to_h)
    elsif ins_hash['INSERT INTO'] == 'players' && ins_hash['VALUES'].length == players_columns.length
      @insert_query[:values] = players_columns.zip(ins_hash['VALUES']).to_h
    elsif ins_hash['INSERT INTO'] == 'players' && !insert_cols.empty?
      @insert_query[:values] = Hash[players_columns.map { |i| [i, ''] }].merge(insert_cols.zip(ins_hash['VALUES']).to_h)
    end

    if ins_hash['INSERT INTO'] == 'player_data'
      @insert_query[:insert] = 'nba_player_data.csv'
    elsif ins_hash['INSERT INTO'] == 'players'
      @insert_query[:insert] = 'nba_players.csv'
    end
  end

  def run_insert
    unless @insert_query.empty?
      @insert_query[:values].each_value(&:strip!)
      @request = @request.insert(@insert_query[:insert])
      @request = @request.values(@insert_query[:values])
      puts @request.run
    end
  end
end