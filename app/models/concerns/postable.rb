module Postable
  extend ActiveSupport::Concern

  included do
    scope :published, -> {
      table = self.table_name
      if I18n.locale == :en
        where.not(published_at_en: nil)
        .where("#{table}.published_at_en <= :now AND (#{table}.expired_at_en is NULL OR #{table}.expired_at_en > :now)", now: Time.current)
      else
        where.not(published_at: nil)
        .where("#{table}.published_at <= :now AND (#{table}.expired_at is NULL OR #{table}.expired_at > :now)", now: Time.current)
      end
    }

    scope :expired, -> {
      table = self.table_name
      if I18n.locale == :en
        where("#{table}.expired_at_en <= ?", Time.current)
      else
        where("#{table}.expired_at <= ?", Time.current)
      end
    }
  end

  # == Instance Methods ====================================================
  def published?
    published_at && Time.current >= published_at && (expired_at.blank? || Time.current < expired_at)
  end

  def en_published?
    published_at_en && Time.current >= published_at_en && (expired_at_en.blank? || Time.current < expired_at_en)
  end

  def expired?
    if I18n.locale == :en
      en_expired_at && Time.current > en_expired_at
    else
      expired_at && Time.current > expired_at
    end
  end

  def no_other_lang?
    if I18n.locale == :en
      !(published?)
    else
      !(en_published?)
    end
  end

  # == Validations ==========================================================
  def time_sequence
    errors.add(:expired_at, '不得早於發佈時間！') if expired_at? && published_at? && (published_at > expired_at)
    errors.add(:expired_at_en, '不得早於英文發佈時間') if expired_at_en? && published_at_en? && (published_at_en > expired_at_en)
  end
end
