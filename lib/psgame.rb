class PsGame
  attr_accessor :title, :platform, :platform_type, :game_type, :ex_price, :actual_price
  def update(options)
    @title = options[:title]
    @platform_type = options[:platform_type]
    @game_type = options[:game_type]
    @ex_price = options[:ex_price]
    @actual_price = options[:actual_price]
  end
  
  def self.from_url(url)
    page = 1
    unparsed = HTTParty.get(url + page.to_s)
    parsed = Nokogiri::HTML(unparsed)
    
     per_page = parsed.css('div.grid-cell__title').css('span').count

    games = {}
    
    total =  parsed.css('div.grid-header__left').css('div').text.strip.split(' ')[2].to_i
    last_page = (total.to_f/per_page.to_f).ceil
    while page <= last_page
      pagination_url = url + page.to_s
        pagination_unparsed = HTTParty.get(pagination_url)
        pagination_parsed = Nokogiri::HTML(pagination_unparsed)
        titles_css = pagination_parsed.css('div.grid-cell__title').css('span')
        game_types_css = pagination_parsed.css('div.grid-cell__left-detail.grid-cell__left-detail--detail-2')
        platform_types_css = pagination_parsed.css('div.grid-cell__left-detail.grid-cell__left-detail--detail-1')
        ex_prices_css = pagination_parsed.css('div.price')
        actual_prices_css = pagination_parsed.css('h3.price-display__price')

        i = 0
        titles_css.each do |title_from_css|
          games[title_from_css.text] =  {
          title: title_from_css.text,
          platform_type: platform_types_css[i].text,
          game_type: game_types_css[i].text,
          ex_price: ex_prices_css[i].text,
          actual_price: actual_prices_css[i].text
          }
          i += 1
          #games.push game
      end
   page += 1
    end
    return games
  end

  def self.from_hash(games)
    result = []
    games.each do |hash|
      game = PsGame.new
      game.update(
        title: hash[:title],
        platform_type: hash[:platform_type],
        game_type: hash[:game_type],
        ex_price: hash[:ex_price],
        actual_price: hash[:actual_price]
      )
      result.push(game)
    end
    return result
  end

  def self.from_xml(path)
    file = File.read(path)
    hash = Ox.load(file, mode: :hash)
    total = self.from_hash(hash.values[0].values[0])
  end

  def self.save_to_json(path, games)
    file = File.new(path, 'w')
    file.puts(games)
    file.close
  end

  def self.read_from_json(path)
    file = File.read(path)
    options = JSON.parse(file)
    result = []
    options.values.each do |hash|
      game = PsGame.new
      game.update(
        title: hash['title'],
        platform_type: hash['platform_type'],
        game_type: hash['game_type'],
        ex_price: hash['ex_price'],
        actual_price: hash['actual_price']
      )
      result.push(game)
    end
    return result
  end

  def show
    puts "Title: #{@title}"
    puts "Details: #{@game_type}, #{@platform_type}"
    puts "The price before discount: #{@ex_price}"
    puts "Discount price: #{@actual_price}"
  end

  def to_xml
    game = Ox::Element.new('game')
    title = Ox::Element.new('title')
    title << @title
    game << title
    platform_type = Ox::Element.new('platform_type')
    platform_type << @platform_type
    game << platform_type
    game_type = Ox::Element.new('game_type')
    game_type << @game_type
    game << game_type
    ex_price = Ox::Element.new('ex_price')
    ex_price << @ex_price
    game << ex_price
    actual_price = Ox::Element.new('actual_price')
    actual_price << @actual_price
    game << actual_price
    game
  end

  def self.save_all_to_xml(path, arr)
    doc = Ox::Document.new
    instruct = Ox::Instruct.new(:xml)
    instruct[:version] = '1.0'
    instruct[:encoding] = 'UTF-8'
    instruct[:standalone] = 'yes'
    doc << instruct
    games_node = Ox::Element.new('games')
    arr.each {|game| games_node << game.to_xml}
    doc << games_node
    Ox.to_file(path, doc)
  end

  def self.save_to_yaml(path, hash)
    file = File.new(path, 'w')
    file.puts(hash.to_yaml)
    file.close
  end 
    
end

