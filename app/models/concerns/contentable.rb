module Contentable
  extend ActiveSupport::Concern

  def content_not_empty
    return validate_presence_for_published('content') if self.model_name != 'Article'

    # Article
    if(self.post_type == 'link')
      validate_presence_for_published('source_link')
    else
      validate_presence_for_published('content')
    end
  end

  def title_not_empty
    validate_presence_for_published('title')
    validate_at_least_one_locale('title')
  end

  def name_not_empty
    validate_presence_for_published('name')
    validate_at_least_one_locale('name')
  end

  def featured_not_equal_to_zero
    errors.add(:featured, '不可以出現「0」') if featured == 0
  end

  def top_not_equal_to_zero
    errors.add(:top, '不可以出現「0」') if top == 0
  end

  def source_link_format
    validate_url_format('source_link')
  end

  private

  def localized_field(base_name, locale)
    return base_name if locale == :'zh-TW'

    if(base_name == 'status')
      "#{locale.to_s.downcase.tr('-', '_')}_#{base_name}"
    else
      "#{base_name}_#{locale.to_s.downcase.tr('-', '_')}"
    end
  end

  def validate_presence_for_published(field_name)
    I18n.available_locales.each do |locale|
      field = localized_field(field_name, locale)
      published = localized_field('published_at', locale)

      if respond_to?(:published_at)
        errors.add(field, '在發布時間有填寫的情況下，不能空白') if self.send(field).blank? && self.send(published).present?
      else
        status = localized_field('status', locale)
        errors.add(field, '在狀態為公開的情況下，不能空白') if self.send(field).blank? && self.send(status) == 'published'
      end
    end
  end

  def validate_at_least_one_locale(field_name)
    field_present = I18n.available_locales.any? do |locale|
      field = localized_field(field_name, locale)
      send(field)&.present?
    end

    errors.add(:base, "至少要輸入一個語系的#{field_name}") unless field_present
  end

  def validate_url_format(field_name)
    I18n.available_locales.each do |locale|
      field = localized_field(field_name, locale)
      errors.add(field, '網址格式錯誤') if self.send(field).present? && !self.send(field).match?(URI::DEFAULT_PARSER.make_regexp)
    end
  end
end
