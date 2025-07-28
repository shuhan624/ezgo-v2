# == Schema Information
#
# Table name: faqs
#
#  id                    :bigint           not null, primary key
#  faq_category_id(分類) :bigint           not null
#  title(標題)           :string
#  title_en(英文標題)    :string
#  status(狀態)          :string           default("published"), not null
#  en_status(英文狀態)   :string           default("hidden"), not null
#  content(內容)         :text
#  content_en(英文內容)  :text
#  translations          :jsonb
#  position(排列順序)    :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_faqs_on_faq_category_id  (faq_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (faq_category_id => faq_categories.id)
#
class Faq < ApplicationRecord

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

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en

  # == Relationships ========================================================
  belongs_to :faq_category

  # == Validations ==========================================================
  validates :faq_category, :status, :en_status, presence: true
  validate :title_not_empty
  validate :content_not_empty

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title title_en status en_status position)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(faq_category)
  end

  # == Instance Methods =====================================================

end
