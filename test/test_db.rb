require 'db'

db = Follotter::DB.new
cf = db.cofriends ['mirakui', 'yositosi']
i = 0
cf.each {|users|
  users.each{|user|
    puts "#{i}:#{user[:id]}"
  }
  i += 1
}

