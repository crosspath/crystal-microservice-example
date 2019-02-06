# We should `require` all models which are used in `belongs_to`,
# otherwise we will get error 'undefined constant'.

require "./user.cr"

class BonusAccount < BaseModel
  table :bonus_accounts do
    has_many bonus_logs : BonusLog

    belongs_to user : User

    column bonuses : Float64
  end
end
