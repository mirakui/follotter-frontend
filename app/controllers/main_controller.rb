require 'db'

class MainController < ApplicationController
  def index
  end

  def cofriends
  end

  def ranking
    cache_path = File.join RAILS_ROOT, 'cache', 'cache.yml'
    cache = YAML.load_file(cache_path);
    @users_count     = cache['users_count']
    @most_followed   = cache['most_followed'] || []
    @most_befollowed = cache['most_befollowed'] || []
    @updated_at      = File.mtime(cache_path)
  end
end
