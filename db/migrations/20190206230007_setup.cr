class Setup::V20190206230007 < Avram::Migrator::Migration::V1
  def migrate
    create User.table_name do
      primary_key id : Int64
      add email : String
      add_timestamps
    end

    create UserOrder.table_name do
      primary_key id : Int64
      add_belongs_to user : User, on_delete: :nullify
      add product : String
      add price : Float64
      add_timestamps
    end

    create BonusAccount.table_name do
      primary_key id : Int64
      add_belongs_to user : User, on_delete: :nullify
      add bonuses : Float64, default: 0.0
      add_timestamps
    end

    create BonusLog.table_name do
      primary_key id : Int64
      add_belongs_to bonus_account : BonusAccount, on_delete: :nullify, references: BonusAccount.table_name
      add_belongs_to user_order : UserOrder, on_delete: :nullify, references: UserOrder.table_name
      add bonuses : Float64, default: 0.0
      add_timestamps
    end

    execute(
      "COMMENT ON COLUMN #{BonusLog.table_name}.bonus_account_id IS " +
      "'Who will receive bonus for inviting new user with this UserOrder?'"
    )
  end

  def rollback
    drop BonusLog.table_name
    drop BonusAccount.table_name
    drop UserOrder.table_name
    drop User.table_name
  end
end
