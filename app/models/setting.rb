# == Schema Information
#
# Table name: settings
#
#  id                 :bigint           not null, primary key
#  name(欄位名稱)     :string           not null
#  slug(slug)         :string
#  category(類別)     :string
#  translations       :jsonb
#  position(排列順序) :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_settings_on_slug  (slug) UNIQUE
#
class Setting < ApplicationRecord
  # == Constants ============================================================
  CATEGORIES = {
       site: 'site',    # 網站資訊
        seo: 'seo',     # SEO & 行銷管理
    contact: 'contact', # 聯絡資訊
     social: 'social',  # 社群連結
       logo: 'logo',    # Logo 圖示
     custom: 'custom'   # Pop Up
  }.freeze

  # == Extensions ===========================================================
  audited
  acts_as_list scope: [:category]
  extend Mobility
  translates :title, :content, :status
  extend FriendlyId
  friendly_id :name, use: :slugged

  # == Attributes ===========================================================
  enum :category, CATEGORIES
  has_one_attached :image
  has_one_attached :image_en

  # == Validations ==========================================================
  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  validates :content, presence: true, if: -> { name.in? %w(site_title copyright footer_desc meta_title meta_keywords meta_desc og_title og_desc) }
  validates :status, presence: true, if: -> { social? }
  # == Scopes ===============================================================
  scope :site_items, -> { where(name: %w(site_title copyright footer_desc logo admin_logo favicon favicon_m)).with_attached_image }
  scope :seo_items, -> { where(name: %w(gtm ga fb_pixel meta_title meta_keywords meta_desc og_title og_desc og_image)) }
  scope :contact_items, -> { where(name: %w(address tel fax email business_hours tax_id_number receivers messenger)) }
  scope :social_items, -> { where(name: %w(facebook instagram line youtube)) }
  scope :custom_items, -> { where(name: 'popup_homepage') }

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  def should_generate_new_friendly_id?
    Mobility.with_locale(:en) do
      slug.blank? || will_save_change_to_name?
    end
  end
end
