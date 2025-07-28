# == Schema Information
#
# Table name: milestones
#
#  id                   :bigint           not null, primary key
#  title(標題)          :string
#  title_en(英文標題)   :string
#  date(年月份)         :date
#  status(狀態)         :string           default("published")
#  en_status(英文狀態)  :string           default("hidden")
#  content(內容)        :text
#  content_en(英文內容) :text
#  translations         :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Milestone < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
    published: 'published',
    hidden: 'hidden'
  }.freeze

  # == Extensions ===========================================================
  audited
  include Contentable
  include Publishing
  extend Mobility
  translates :alt

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en
  has_one_attached :image

  # == Relationships ========================================================

  # == Validations ==========================================================
  validates :status, :en_status, :date, presence: true
  validate :title_not_empty

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title title_en date status en_status)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
end
