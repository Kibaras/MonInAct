require 'rubygems'
require 'mongo'
require 'twitter'

require './config'

class TweetArchiver
  def initialize(tag)
    Mongo::Logger.logger.level = ::Logger::INFO
    connection = Mongo::Client.new(DATABASE_ADDRS, :database => DATABASE_NAME)
    @tweets = connection[COLLECTION_NAME]

    # @tweets.indexes.create_one({:id => 1}, :unique => true)
    @tweets.indexes.create_one({:tags => 1, :id => -1})

    @tag = tag
    @tweets_found = 0
  end

  def update
    puts "Запускается поиск в твиттер для '#{@tag}'"
    save_tweets_for(@tag)
    print "Сохранено твитов: #{@tweets_found}.\n\n"
  end

  private

  def save_tweets_for(term)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = CONSUMER_KEY
      config.consumer_secret     = CONSUMER_SECRET
      config.access_token        = ACCESS_TOKEN
      config.access_token_secret = ACCESS_TOKEN_SECRET
    end

    client.search(term).collect do |tweet|
      @tweets_found += 1
      tweet_with_tag = tweet.to_hash.merge!({:tags => [term]})
      @tweets.insert_one(tweet_with_tag, :ordered => false)
    end
  end
end