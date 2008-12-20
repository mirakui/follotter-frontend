require 'mysql'
require 'pit'
require 'follotter_constants'
require 'queries'

module Follotter
  class DB
    include Constants
    include Queries

    def initialize
      conf = Pit.get('folloter_mysql', :require=>{
        'username' => 'username',
        'password' => 'password',
        'database' => 'database',
        'host'=> 'host'
      })
      @db = Mysql.new conf['host'], conf['username'], conf['password'], conf['database']

      @statements = {
      }
    end

    def prepare(q)
      @db.prepare(q)
    end

    def query(q)
      @db.query(q)
    end

    def close
      @db.close
    end
  end
end
