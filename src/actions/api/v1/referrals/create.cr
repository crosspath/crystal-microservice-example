require "../../../../operations/referral_operation.cr"

class Api::V1::Referrals::Create < ApiAction
  default_format :json

  param referrer : Int32
  param order : Int32

  route do
    form_params = Avram::Params.new(
      user_order_id: order,
      referrer_id:   referrer
    )

    operation = nil

    ReferralOperation.run(form_params) do |operation, result|
      return response_success(bonuses: operation.bonuses) if result
    end

    response_error(operation ? operation.error_code : 500)
  rescue e
    response_error(500, e)
  end
end
