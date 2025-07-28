# frozen_string_literal: true

# == Schema Information
#
# Table name: article_categories
#
#  id                  :bigint           not null, primary key
#  name(分類名稱)      :string
#  name_en(英文名稱)   :string
#  status(狀態)        :string           default("published"), not null
#  en_status(英文狀態) :string           default("hidden"), not null
#  slug(slug)          :string
#  translations        :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_article_categories_on_slug  (slug) UNIQUE
#
class ArticleCategory < ApplicationRecord

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
  translates :abstract, :alt
  extend FriendlyId
  friendly_id :slug

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en
  has_one_attached :image
  has_one_attached :image_en

  # == Relationships ========================================================
  has_and_belongs_to_many :articles, join_table: "article_article_categories"
  has_one :seo, as: :seoable, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :seo, reject_if: :all_blank
  delegate :meta_title, :meta_desc, :meta_keywords, :og_title, :og_desc, :og_image, :og_image_en, :canonical, to: :seo, allow_nil: true

  # == Validations ==========================================================
  validates :status, :en_status, presence: true
  validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-z0-9\-]+\z/}
  validates :canonical, format: { without: /\s/ }
  validate :name_not_empty

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(id name name_en slug status en_status position)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(articles)
  end

  # == Instance Methods =====================================================
end
