module BrowserTypes
  extend self
  CHROME = :chrome
  FIREFOX = :firefox
  IE11 = :IE_11
  EDGE = :edge
  IE10 = :ie10

  def enum_values
    [CHROME, FIREFOX, IE11, EDGE, IE10]
  end
end
