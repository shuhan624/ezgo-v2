# == Schema Information
#
# Table name: download_categories
#
#  id                  :bigint           not null, primary key
#  name(名稱)          :string
#  name_en(分類名稱)   :string
#  slug(slug)          :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  translations        :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_download_categories_on_slug  (slug) UNIQUE
#
class DownloadCategory < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
    published: 'published',
    hidden: 'hidden'
  }.freeze

  # == Extensions ===========================================================
  audited
  acts_as_list
  extend FriendlyId
  friendly_id :slug

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en

  # == Relationships ========================================================
  has_many :downloads
  has_one :seo, as: :seoable
  accepts_nested_attributes_for :seo, reject_if: :all_blank
  delegate :meta_title, :meta_desc, :meta_keywords, :og_title, :og_desc, :og_image, :canonical, to: :seo, allow_nil: true

  # == Validations ==========================================================
  validates :name, uniqueness: true, presence: true
  validates :status, presence: true
  validates :slug, presence: true, format: {with: /\A[a-z0-9\-]+\z/}
  validates :canonical, format: { without: /\s/ }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(id name name_en slug status en_status position)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(downloads)
  end

  # == Instance Methods =====================================================
end
