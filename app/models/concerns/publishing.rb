module Publishing
  extend ActiveSupport::Concern

  included do
    scope :publishing, -> {
      if I18n.locale == :en
        where(en_status: 'published')
      else
        where(status: 'published')
      end
    }
  end

  def no_other_lang?
    (I18n.locale == :en) ? (status == 'hidden') : (en_status == 'hidden')
  end
end
