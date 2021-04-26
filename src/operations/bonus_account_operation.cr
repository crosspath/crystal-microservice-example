class BonusAccountOperation < BonusAccount::SaveOperation
  permit_columns bonuses
end
