require "../../../../operations/referral_operation.cr"

class Api::V1::Referrals::Create < ApiAction
  default_format :json

  param referrer : String
  param order : String

  post "/api/v1/referrals" do
    form_params = Avram::Params.new({
      "user_order_id" => [order],
      "referrer_id" => [referrer]
    })

    operation = nil

    ReferralOperation.run(form_params) do |result, saved|
      operation = result
      return response_success(bonuses: result.bonuses) if saved
    end

    response_error(operation ? operation.error_code : 500)
  rescue e
    response_error(500, e)
  end
end
