require "../queries/user_query.cr"
require "../queries/user_order_query.cr"

class ReferralForm < Avram::VirtualForm
  # unable to use `Int32?`, got error "virtual must use just one type"
  # lib/avram/src/avram/virtual.cr: line 57, sets type `Avram::Field(...)?` for fields

  virtual user_order_id : Int32
  virtual referrer_id : Int32

  getter bonuses : Float64, error_code : Int32?

  @referrer : User?
  @order    : UserOrder?

  @bonuses    = 0.0
  @error_code = nil

  def referrer?
    @referrer ||= begin
      # referrer_id is Avram::FillableField(Int32 | Nil)
      value = referrer_id.value
      if value.nil?
        nil
      else
        UserQuery.new.id(value.as(Int32)).preload_bonus_account.first?
      end
    end
  end

  def order?
    @order ||= begin
      # user_order_id is Avram::FillableField(Int32 | Nil)
      value = user_order_id.value
      if value.nil?
        nil
      else
        UserOrderQuery.new.id(value.as(Int32)).preload_bonus_log.first?
      end
    end
  end

  def valid?
    @error_code = nil

    unless referrer?
      @error_code = 110
      return false
    end

    unless order?
      @error_code = 111
      return false
    end

    if order?.as(UserOrder).user_id == referrer?.as(User).id
      @error_code = 112
      return false
    end

    if order?.as(UserOrder).bonus_log
      @error_code = 113
      return false
    end

    true
  end

  def save
    return false unless valid?

    present_referrer = referrer?.as(User)
    present_order    = order?.as(UserOrder)

    account = present_referrer.bonus_account
    account ||= BonusAccountForm.create!(
      user_id: present_referrer.id,
      bonuses: 0.0
    )

    @bonuses = present_order.bonus_amount

    BonusLogForm.create!(
      bonus_account_id: account.id,
      user_order_id: present_order.id,
      bonuses: @bonuses
    )

    true
  end
end
