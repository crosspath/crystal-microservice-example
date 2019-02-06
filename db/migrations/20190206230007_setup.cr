class Setup::V20190206230007 < Avram::Migrator::Migration::V1
  def migrate
    # `create` always includes columns for `id` & timestamps
    # NOTE: models have column with type Float64 while migration declares Float.

    create User::TABLE_NAME do
      add email : String
    end

    create UserOrder::TABLE_NAME do
      add_belongs_to user : User, on_delete: :nullify
      add product : String
      add price : Float
    end

    create BonusAccount::TABLE_NAME do
      add_belongs_to user : User, on_delete: :nullify
      add bonuses : Float, default: 0.0
    end

    create BonusLog::TABLE_NAME do
      add_belongs_to bonus_account : BonusAccount, on_delete: :nullify
      add_belongs_to user_order : UserOrder, on_delete: :nullify
      add bonuses : Float, default: 0.0
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
