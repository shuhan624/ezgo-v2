# == Schema Information
#
# Table name: articles
#
#  id                            :bigint           not null, primary key
#  default_category_id(預設分類) :bigint
#  title(標題)                   :string
#  title_en(英文標題)            :string
#  slug(slug)                    :string
#  post_type(文章類型)           :string           default("post")
#  featured(精選項目)            :integer
#  top(置頂)                     :integer
#  published_at(發布時間)        :datetime
#  published_at_en(英文發布時間) :datetime
#  expired_at(下架時間)          :datetime
#  expired_at_en(英文下架時間)   :datetime
#  deleted_at(刪除時間)          :datetime
#  content(內容)                 :text
#  content_en(英文內容)          :text
#  translations                  :jsonb
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_articles_on_default_category_id  (default_category_id)
#  index_articles_on_deleted_at           (deleted_at)
#  index_articles_on_slug                 (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (default_category_id => article_categories.id)
#
class Article < ApplicationRecord
  # == Constants ============================================================
  POST_TYPE = {
    post: 'post', # 文章內容
    link: 'link', # 外部連結
  }.freeze

  # == Extensions ===========================================================
  audited
  include Contentable
  include Postable
  extend Mobility
  translates :abstract, :source_link, :youtube, :alt
  extend FriendlyId
  friendly_id :slug
  acts_as_ordered_taggable_on :tags, :en_tags
  acts_as_paranoid

  # == Attributes ===========================================================
  enum :post_type, POST_TYPE
  has_one_attached :image
  has_one_attached :image_en

  # == Relationships ========================================================
  belongs_to :default_category, foreign_key: 'default_category_id', class_name: 'ArticleCategory'
  has_and_belongs_to_many :article_categories, join_table: "article_article_categories"
  has_one :seo, as: :seoable, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :seo, reject_if: :all_blank
  delegate :meta_title, :meta_title_en, :meta_desc, :meta_desc_en, :meta_keywords, :meta_keywords_en, :og_title, :og_title_en, :og_desc, :og_desc_en, :og_image, :og_image_en, :canonical, to: :seo, allow_nil: true
  has_many :figures, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :imageable, as: :imageable
  accepts_nested_attributes_for :figures, reject_if: :all_blank, allow_destroy: true

  # == Validations ==========================================================
  validates :post_type, :default_category, :article_categories, presence: true
  validates :featured, :top, uniqueness: true, allow_nil: true
  validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-z0-9\-]+\z/}
  validates :canonical, format: { without: /\s/ }
  validate :source_link_format
  validate :title_not_empty
  validate :content_not_empty
  validate :time_sequence
  validate :featured_not_equal_to_zero
  validate :top_not_equal_to_zero
  validates :image, :image_en,
            content_type: [:png, :jpg, :jpeg],
            size: { between: 1.kilobyte..1.megabytes, message: '檔案大小不得超過 1Mb' }

  # == Scopes ===============================================================
  scope :featured_items, -> { where.not(featured: nil) }

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title title_en slug post_type featured top published_at published_at_en)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(article_categories)
  end

  # == Instance Methods =====================================================

end
