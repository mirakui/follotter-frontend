require 'db'

class MainController < ApplicationController
  def index
  end

  def cofriends
  end

  def ranking
    db = Follotter::DB.new
    @user_count      = db.users_count
    @most_followed   = db.most_followed(:limit=>10)
    @most_befollowed = db.most_befollowed(:limit=>10)
    db.close
  end
end
