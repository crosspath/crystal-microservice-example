require "../../../../forms/referral_form.cr"

class Api::V1::Referrals::Create < ApiAction
  param referrer : Int32
  param order : Int32

  route do
    order    = params.get(:order)
    referrer = params.get(:referrer)

    form_params = Avram::Params.new(
      user_order_id: order.to_i32,
      referrer_id:   referrer.to_i32
    )

    form = ReferralForm.new(form_params)
    if form.save
      return response_success(bonuses: form.bonuses)
    end

    response_error(form.error_code || 500)
  rescue e
    if Lucky::Env.show_exceptions?
      response_error(500, message: e.message.as(String), trace: e.backtrace)
    else
      response_error(500)
    end
  end
end
