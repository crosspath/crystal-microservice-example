require "./user.cr"

class UserOrder < BaseModel
  table :user_orders do
    has_one bonus_log : BonusLog?

    belongs_to user : User

    column product : String
    column price : Float64
  end

  BONUS = 10 # percent

  def bonus_amount
    self.price * BONUS / 100.0
  end
end
