require "./bonus_account.cr"
require "./user_order.cr"

class BonusLog < BaseModel
  table :bonus_logs do
    belongs_to bonus_account : BonusAccount
    belongs_to user_order : UserOrder

    column bonuses : Float64
  end
end
