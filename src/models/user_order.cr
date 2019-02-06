require "./user.cr"

class UserOrder < BaseModel
  table :user_orders do
    has_many bonus_logs : BonusLog

    belongs_to user : User

    column product : String
    column price : Float64
  end
end
