module Follotter
  module Queries
    def users_count(param={})
      param[:language] ||= 'ja'
      q = "SELECT count(*) FROM users WHERE language=?"
      st = prepare(q)
      st.execute(param[:language])
      st.fetch
    end

    def most_befollowed(param={})
      param[:language] ||= 'ja'
      param[:limit]    ||= 100

      q = <<-QUERY
SELECT
  screen_name,
  followers_count,
  profile_image_url
FROM
  users
WHERE
  language=?
ORDER BY
  followers_count DESC
LIMIT
  ?
      QUERY
      st = prepare(q)
      st.execute(param[:language], param[:limit])

      users = []
      st.each do |u|
        users.push({
          :screen_name=>u[0],
          :followers_count=>u[1],
          :profile_image_url=>u[2].to_mini
        })
      end
      users
    end

    def most_followed(param={})
      param[:language] ||= 'ja'
      param[:limit]    ||= 100

      q = <<-QUERY
SELECT
  screen_name,
  friends_count,
  profile_image_url
FROM
  users
WHERE
  language=?
ORDER BY
  friends_count DESC
LIMIT
  ?
      QUERY
      st = prepare(q)
      st.execute(param[:language], param[:limit])

      users = []
      st.each do |u|
        users.push({
          :screen_name=>u[0],
          :friends_count=>u[1],
          :profile_image_url=>u[2].to_mini
        })
      end
      users
    end

    def update_language(param)
      q = <<-QUERY
UPDATE
  users
SET
  language=?
WHERE
  screen_name=?
      QUERY
      st = prepare(q)
      st.execute(param[:language], param[:screen_name])
    end

    def friends(param)
      q = <<-QUERY
SELECT
  u2.screen_name,
  u2.profile_image_url
FROM
  users u1, users u2, friendships f
WHERE
  u1.id = f.user_id
  AND
  u2.id = f.friend_id
  AND
  u1.screen_name=?
      QUERY
      st = prepare(q)
      st.execute(param[:screen_name])

      users = []
      st.each do |u|
        users.push({
          :id=>u[0],
          :icon=>u[1].to_mini
        })
      end
      users
    end

    def followers(param)
      q = <<-QUERY
SELECT
  u1.screen_name,
  u1.profile_image_url
FROM
  users u1, users u2, friendships f
WHERE
  u1.id = f.user_id
  AND
  u2.id = f.friend_id
  AND
  u2.screen_name=?
      QUERY
      st = prepare(q)
      st.execute(param[:screen_name])

      users = []
      st.each do |u|
        users.push({
          :id=>u[0],
          :icon=>u[1].to_mini
        })
      end
      users
    end
  end
end

class String
  def to_mini
    self.gsub(/_normal\./, '_mini.')
  end
end
