require 'bson'
require 'mongo'

class TweetArchiver
  def initialize(tag)
    connection = Mongo::Cnnection.new()
  end

end