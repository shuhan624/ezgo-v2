# == Schema Information
#
# Table name: partners
#
#  id                  :bigint           not null, primary key
#  name(名稱)          :string
#  name_en(英文名稱)   :string
#  slug(slug)          :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  position(排列順序)  :integer
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug) UNIQUE
#
class Partner < ApplicationRecord

  # == Constants ============================================================
  STATUS = {
    published: 'published',
    hidden: 'hidden'
  }.freeze

  # == Extensions ===========================================================
  audited
  acts_as_list
  include Contentable
  include Publishing
  extend Mobility
  translates :link, :alt
  extend FriendlyId
  friendly_id :name_en, use: :slugged

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en
  has_one_attached :image
  has_one_attached :image_en

  # == Relationships ========================================================

  # == Validations ==========================================================
  validates :name_en, uniqueness: true, presence: true
  validates :name, :status, :en_status, presence: true
  validates :image, attached: true, if: -> { zh_tw_published? }
  validates :image_en, attached: true, if: -> { en_published? }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(name name_en slug status en_status position)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
  def should_generate_new_friendly_id?
    slug.blank? || name_en_changed?
  end
end
