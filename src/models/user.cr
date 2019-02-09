class User < BaseModel
  table :users do
    has_one bonus_account : BonusAccount?
    has_many user_orders : UserOrder

    column email : String
  end
end
