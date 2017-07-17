Given(/^eyes application name is "([^"]*)"$/) do |name|
  Applitools::Calabash::EyesSettings.instance.app_name = name
end

Given(/^eyes test name is "([^"]*)"$/) do |name|
  Applitools::Calabash::EyesSettings.instance.test_name = name
end

Given(/^eyes vieport size is "([^"]*)"$/) do |size|
  Applitools::Calabash::EyesSettings.instance.viewport_size = Applitools::RectangleSize.from_any_argument(size).to_h
end

Given(/^eyes API key "([^"]*)"$/) do |key|
  Applitools::Calabash::EyesSettings.instance.applitools_api_key = key
end

Given /^eyes tag is "([^"]*)"$/ do |tag|
  Applitools::Calabash::EyesSettings.instance.tag = tag
end

Given /^calabash screenshot dir is "([^"]*)"$/ do |path|
  Applitools::Calabash::EyesSettings.instance.screenshot_dir = path
end

Given /^calabash temp dir is "([^"]*)"$/ do |path|
  Applitools::Calabash::EyesSettings.instance.tmp_dir = path
end

Given /^calabash log path is "([^"]*)"$/ do |path|
  Applitools::Calabash::EyesSettings.instance.log_dir = path
end

Given /^eyes logfile is "([^"]*)"$/ do |logfile_path|
  Applitools::Calabash::EyesSettings.instance.log_file = logfile_path
end

Given /^clear directories$/ do
  Applitools::Calabash::Utils.clear_directories(Applitools::Calabash::EyesSettings.instance)
end

Given /^create directories$/ do
  Applitools::Calabash::Utils.create_directories(Applitools::Calabash::EyesSettings.instance)
end

Given /^set it up$/ do
  p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DIRS!!!!!!!!!!!1"
  step %{clear directories}
  step %{create directories}
  Applitools::Calabash::EyesSettings.instance.needs_setting_up = false
end

Then /^open eyes$/ do
  eyes_settings = Applitools::Calabash::EyesSettings.instance
  eyes_settings.eyes ||= Applitools::Images::Eyes.new.tap do |eyes|
    eyes.api_key = eyes_settings.applitools_api_key
    log_file_path = File.join(eyes_settings.log_prefix, eyes_settings.log_file)
    eyes.log_handler = Logger.new(File.new(log_file_path, 'w+'))
  end

  eyes_settings.eyes.open eyes_settings.options_for_open unless eyes_settings.eyes.open?
end

