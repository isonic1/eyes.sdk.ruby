require 'rspec/expectations'

RSpec::Matchers.define :match_baseline do |expected, tag|
  match do |actual|
    raise Applitools::EyesIllegalArgument.new "Expected #{expected} to be a Applitools::EyesBase instance, but got #{expected.class.name}." unless expected.is_a? Applitools::EyesBase

    eyes_selenium_target = Applitools::ClassName.new('Applitools::Selenium::Target')
    eyes_images_target = Applitools::ClassName.new('Applitools::Images::Target')

    case actual
      when eyes_selenium_target, eyes_images_target
        result = expected.check(tag, actual)
        return result if result.class if [TrueClass, FalseClass]
        return result.as_expected? if result.respond_to? :as_expected?
      else
        false
    end
  end
end