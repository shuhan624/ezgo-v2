# == Schema Information
#
# Table name: home_slides
#
#  id                            :bigint           not null, primary key
#  title(標題)                   :text
#  title_en(英文標題)            :text
#  published_at(發布時間)        :datetime
#  published_at_en(英文發布時間) :datetime
#  expired_at(下架時間)          :datetime
#  expired_at_en(英文下架時間)   :datetime
#  slide_type(輪播類型)          :string           default("image"), not null
#  translations                  :jsonb
#  position(排列順序)            :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
class HomeSlide < ApplicationRecord
  # == Constants ============================================================
  TYPES = {
    image: 'image',
    video: 'video',
      gif: 'gif'
  }.freeze

  # == Extensions ===========================================================
  audited
  acts_as_list
  include Contentable
  include Postable
  extend Mobility
  translates :desc, :link, :alt

  # == Attributes ===========================================================
  enum :slide_type, TYPES
  has_one_attached :banner
  has_one_attached :banner_m
  has_one_attached :banner_en
  has_one_attached :banner_m_en

  # == Relationships ========================================================

  # == Validations ==========================================================
  validates :banner, :banner_m, attached: true
  validates :banner_en, :banner_m_en, attached: true, if: -> { en_published? }
  validates :slide_type, presence: true
  validate :time_sequence

  def time_sequence
    errors.add(:expired_at, '不得早於發佈時間！') if expired_at? && published_at? && (published_at > expired_at)
  end

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title title_en slide_type position)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
end
