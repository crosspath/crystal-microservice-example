require "../../../../forms/referral_form.cr"

class Api::V1::Referrals::Create < ApiAction
  param referrer : Int32
  param order : Int32

  route do
    form_params = Avram::Params.new(
      user_order_id: order,
      referrer_id:   referrer
    )

    form = ReferralForm.new(form_params)
    if form.save
      return response_success(bonuses: form.bonuses)
    end

    response_error(form.error_code || 500)
  rescue e
    response_error(500, e)
  end
end
