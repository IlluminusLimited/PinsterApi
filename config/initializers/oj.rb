require 'oj'

Oj::Rails.set_encoder
Oj::Rails.set_decoder
Oj::Rails.optimize(Array, BigDecimal, Hash, Range, Regexp, Time)