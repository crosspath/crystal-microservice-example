require "../queries/user_query.cr"
require "../queries/user_order_query.cr"

class ReferralForm < Avram::VirtualForm
  virtual user_order_id : Int32
  virtual referrer_id : Int32

  getter bonuses

  def validate
    # `first?` returns nil or record (User)
    @referrer = UserQuery.id(referrer_id).first?
    referrer_id.add_error 110 unless @referrer

    @order = UserOrderQuery.id(user_order_id).first?
    user_order_id.add_error 111 unless @order

    if @order && @referrer
      user_order_id.add_error 112 if @order.user_id == @referrer.id
      user_order_id.add_error 113 if @order.bonus_log
    end

    valid?
  end

  def save
    account = @referrer.bonus_account || BonusAccount.new(user_id: @referrer.id).save
    @bonuses = @order.bonus_amount

    @order.create_bonus_log!(
      bonus_account_id: account.id,
      user_order_id: @order.id,
      bonuses: @bonuses
    )
  end
end
