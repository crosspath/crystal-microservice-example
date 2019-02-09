require "./../../src/queries/user_query.cr"

module DataGenerator
  ALPHA = ('a'..'z').to_a
  ALPHA_NUM = ALPHA + (0..9).to_a

  extend self

  def email
    name_length   = rand(18) + 2
    domain_length = rand(12) + 2
    zone_length   = rand(4)  + 2

    name   = name_length.times.map   { |t| ALPHA_NUM.sample }.join
    domain = domain_length.times.map { |t| ALPHA_NUM.sample }.join
    zone   = zone_length.times.map   { |t| ALPHA.sample }.join

    "#{name}@#{domain}.#{zone}"
  end

  def product
    length = rand(18) + 2
    length.times.map { |t| ALPHA_NUM.sample }.join
  end

  def price
    # original: keep 2 digits after comma/dot (e.g. 1.23)
    # got error "wrong number of arguments for 'Float64#ceil' (given 1, expected 0)"
    # (rand * 100).ceil(2)

    (rand * 10000).ceil / 100
  end

  def orders_count
    rand(3)
  end

  def referrer
    UserQuery.random
  end

  def coin?
    rand(2) == 0
  end
end
