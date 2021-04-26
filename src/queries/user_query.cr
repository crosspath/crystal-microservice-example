require "../models/user.cr"

class UserQuery < User::BaseQuery
  class IdInterval
    DB.mapping({
      min_id: Int64,
      max_id: Int64
      # expected: Hash
      # should not be `max_id : Int32` (space before ':')
    })
  end

  def self.random
    sql = <<-SQL
      SELECT Min(id) AS min_id, Max(id) AS max_id
      FROM #{User.table_name}
    SQL
    d = AppDatabase.run do |db|
      # Raises `DB::Error` if there were no rows, or if there were more than one row.
      db.query_one sql, as: IdInterval
    end

    boundary = rand(d.max_id - d.min_id) + d.min_id

    self.new.id.gte(boundary).preload_bonus_account.first? # returns User or nil
  end
end
