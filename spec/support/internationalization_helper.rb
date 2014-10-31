module InternationalizationHelper
  def t string, *args
    I18n.t string, *args
  end
end
