# == Schema Information
#
# Table name: seos
#
#  id                  :bigint           not null, primary key
#  seoable_type        :string           not null
#  seoable_id          :bigint           not null
#  canonical(標準網址) :string
#  translations        :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_seos_on_seoable  (seoable_type,seoable_id)
#
class Seo < ApplicationRecord
  # == Constants ============================================================

  # == Attributes ===========================================================
  has_one_attached :og_image
  has_one_attached :og_image_en

  # == Extensions ===========================================================
  extend Mobility
  translates :meta_title, :meta_keywords, :meta_desc, :og_title, :og_desc

  # == Relationships ========================================================
  belongs_to :seoable, polymorphic: true

  # == Validations ==========================================================

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
end
