require 'db'

class ApiController < ApplicationController
  def friends
    screen_name = params[:id]
    result = ''
    begin
      if screen_name
        db = Follotter::DB.new
        friends = db.friends :screen_name=>params[:id]
        result = {'id'=>screen_name, 'friends' => friends}
        db.close
      else
        result = {'error'=>'id was empty'}
      end
    rescue => e
      result = {'error'=>e.to_s}
    end
    render :json => result.to_json
  end

  def followers
    screen_name = params[:id]
    result = ''
    begin
      if screen_name
        db = Follotter::DB.new
        friends = db.followers :screen_name=>params[:id]
        result = {'id'=>screen_name, 'followers' => friends}
        db.close
      else
        result = {'error'=>'id was empty'}
      end
    rescue => e
      result = {'error'=>e.to_s}
    end
    render :json => result.to_json
  end

end
