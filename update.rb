require "./config"
require './tweet_archiver'

TAGS.each{|tag|
  archive = TweetArchiver.new(tag)
  archive.update
}