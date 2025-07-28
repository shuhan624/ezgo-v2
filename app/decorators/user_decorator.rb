class UserDecorator < ApplicationDecorator
  delegate_all

  def display_name
    object.name || object.email
  end

  def avatar
    object.line? ? object.line_avatar : 'users/user-profile.png'
  end

  def country_name
    if object.country.present?
      country = ISO3166::Country.new(object.country)
      country.translation('zh-TW')
    end
  end
end
