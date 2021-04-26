class UserOrderFactory < Avram::Factory
  def initialize
    user_id 1
    product "name"
    price   1.0
  end
end
