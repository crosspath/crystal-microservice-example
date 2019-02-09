require "../spec/support/boxes/**"
require "../spec/support/data_generator.cr"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::CreateRequiredSeeds` if you need to create data *required* for your
# app to work.
class Db::CreateSampleSeeds < LuckyCli::Task
  summary "Add sample database records helpful for development"

  def call
    # Using a LuckyRecord::Box:
    #
    # Use the defaults, but override just the email
    # UserBox.create &.email("me@example.com")

    1_000.times do
      Avram::Repo.transaction do
        user = UserBox.create &.email(DataGenerator.email)

        DataGenerator.orders_count.times do |t|
          order = UserOrderBox.create do |box|
            box.user_id(user.id)
            box.product(DataGenerator.product)
            box.price(DataGenerator.price)
          end

          if t == 0 && DataGenerator.coin?
            referrer = DataGenerator.referrer
            if referrer
              account = referrer.bonus_account
              account ||= BonusAccountBox.create(&.user_id(referrer.id))

              log = BonusLogBox.create do |box|
                box.user_order_id(order.id)
                box.bonus_account_id(account.id)
                box.bonuses(order.bonus_amount)
              end

              BonusAccountForm.update!(
                account,
                bonuses: account.bonuses + log.bonuses
              )
            end
          end
        end

        true
        # Crystal compiler expects that `transaction` will return Bool,
        # not Bool or nil
      end
    end

    # Using a form:
    #
    # UserForm.create!(email: "me@example.com", name: "Jane")
    puts "Done adding sample data"
  end
end
