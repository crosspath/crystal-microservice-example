struct Float64
  module Lucky
    def from_db!(value : PG::Numeric)
      value.to_f
    # BUG: Arithmetic overflow in `PG::Numeric#to_f64` for
    # value = 0.46999999999999886
    rescue e : OverflowError
      value.to_s.to_f
    end
  end
end
