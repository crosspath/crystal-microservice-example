class BonusLogForm < BonusLog::SaveOperation
  permit_columns bonus_account_id, user_order_id, bonuses
end
