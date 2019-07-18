class BonusAccountForm < BonusAccount::SaveOperation
  permit_columns bonuses
end
