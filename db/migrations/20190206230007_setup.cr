class Setup::V20190206230007 < Avram::Migrator::Migration::V1
  def migrate
    create User::TABLE_NAME do
      primary_key id : Int32
      add email : String
    end

    create UserOrder::TABLE_NAME do
      primary_key id : Int32
      add_belongs_to user : User, on_delete: :nullify
      add product : String
      add price : Float64
    end

    create BonusAccount::TABLE_NAME do
      primary_key id : Int32
      add_belongs_to user : User, on_delete: :nullify
      add bonuses : Float64, default: 0.0
    end

    create BonusLog::TABLE_NAME do
      primary_key id : Int32
      add_belongs_to bonus_account : BonusAccount, on_delete: :nullify
      add_belongs_to user_order : UserOrder, on_delete: :nullify
      add bonuses : Float64, default: 0.0
    end

    execute(
        "COMMENT ON COLUMN #{BonusLog::TABLE_NAME}.bonus_account_id IS "+
        "'Who will receive bonus for inviting new user with this UserOrder?'"
    )
  end

  def rollback
    drop BonusLog::TABLE_NAME
    drop BonusAccount::TABLE_NAME
    drop UserOrder::TABLE_NAME
    drop User::TABLE_NAME
  end
end
