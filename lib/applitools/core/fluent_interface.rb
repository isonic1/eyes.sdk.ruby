module Applitools::FluentInterface
  def ignore_caret(value = false)
    options[:ignore_caret] = value ? true : false
    self
  end

  def timeout(value)
    options[:timeout] = value.to_i
    self
  end

  def trim(value = true)
    options[:trim] = value ? true : false
    self
  end

  def ignore_mismatch(value)
    options[:ignore_mismatch] = value ? true : false
    self
  end

  def match_level(value)
    raise Applitools::EyesError unless Applitools::MATCH_LEVEL.keys.include? value
    options[:match_level] = Applitools::MATCH_LEVEL[value]
    self
  end
end
