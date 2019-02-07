require "../../../../forms/referral_form.cr"

class Api::V1::Referals::Create < ApiAction
  param referrer : Int32
  param order : Int32

  route do
    form = ReferralForm.new(
      user_order_id: params[:order]?,
      referrer_id:   params[:referrer]?
    )
    form.save if form.validate
    json({bonuses: form.bonuses})
  end
end
