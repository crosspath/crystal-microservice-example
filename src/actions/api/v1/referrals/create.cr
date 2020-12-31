require "../../../../forms/referral_form.cr"

class Api::V1::Referrals::Create < ApiAction
  default_format :json

  param referrer : Int32
  param order : Int32

  route do
    form_params = Avram::Params.new(
      user_order_id: order,
      referrer_id:   referrer
    )

    form = nil

    ReferralForm.run(form_params) do |operation, result|
      form = operation
      return response_success(bonuses: form.bonuses) if result
    end

    response_error(form ? form.error_code : 500)
  rescue e
    response_error(500, e)
  end
end
