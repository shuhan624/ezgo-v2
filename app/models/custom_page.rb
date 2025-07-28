# == Schema Information
#
# Table name: custom_pages
#
#  id                           :bigint           not null, primary key
#  title(頁面標題)              :string
#  title_en(英文標題)           :string
#  slug(slug)                   :string
#  content(內容)                :text
#  content_en(英文內容)         :text
#  status(狀態)                 :string           default("published")
#  en_status(英文狀態)          :string           default("published")
#  default_page(是否為預設頁面) :boolean          default(FALSE)
#  custom_type(頁面類型)        :string           default("info")
#  translations                 :jsonb
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_custom_pages_on_slug  (slug) UNIQUE
#
class CustomPage < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
    published: 'published',
       hidden: 'hidden'
  }.freeze

  TYPE = {
     design: 'design',  # 靜態頁面設計，不可從後台管理
       info: 'info',    # 頁面管理內容，可從後台管理
    archive: 'archive', # 彙整頁
  }.freeze

  # == Extensions ===========================================================
  audited
  include Contentable
  include Publishing
  extend Mobility
  translates :menu
  extend FriendlyId
  friendly_id :slug

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en
  enum :custom_type, TYPE

  # == Relationships ========================================================
  has_one :seo, as: :seoable, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :seo, reject_if: :all_blank
  delegate :meta_title, :meta_desc, :meta_keywords, :og_title, :og_desc, :og_image, :og_image_en, :canonical, to: :seo, allow_nil: true

  # == Validations ==========================================================
  validates :slug, uniqueness: true, presence: true, format: {with: /\A[a-z0-9\-]+\z/}, exclusion: { in: %w(user login logout sign_up en ja ko zh-TW) }
  validates :custom_type, :status, :en_status, presence: true
  validate :title_not_empty
  validate :non_default_page_max_number, on: :create

  def non_default_page_max_number
    errors.add(:base, '擴充頁面數量最多為 5 個') if CustomPage.non_default_pages.count >= 5
  end

  # == Scopes ===============================================================
  scope :non_default_pages, -> { where(default_page: false) }
  scope :default_pages, -> { where(default_page: true) }
  scope :seo_pages, -> { where(custom_type: %i[design archive]) }

  # == Callbacks ============================================================
  # 要在資料庫更新後才觸發，因此要用 after_commit，不能使用 after_update or after_save
  after_commit :update_sitemap, if: -> { saved_change_to_status? || saved_change_to_en_status? }

  def update_sitemap
    return if Rails.env.test? || Rails.env.development?
    SitemapRefreshJob.perform_later
  end
  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  def non_default_page?
    !default_page
  end
end
