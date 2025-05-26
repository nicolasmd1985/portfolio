class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    return nil unless parsed_locale
    return nil unless I18n.available_locales.map(&:to_s).include?(parsed_locale)
    parsed_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
