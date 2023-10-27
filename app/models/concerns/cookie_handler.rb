# frozen_string_literal: true

module CookieHandler
  extend ActiveSupport::Concern

  def get_cookie(cookie_name)
    cookies.signed[cookie_name]
  end
end
