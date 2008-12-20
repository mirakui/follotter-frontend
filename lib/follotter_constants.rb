module Follotter
  module Constants
    BASE_PATH = File.join File.dirname(__FILE__), '../'
    CHACHE_DIR = File.join BASE_PATH, 'chache'
    USERS_TABLE_NAME = 'users'
    FRIENDSHIPS_TABLE_NAME = 'friendships'
    FOLLOWERS_COUNT_RANKING_LIMIT = 100
  end
end
