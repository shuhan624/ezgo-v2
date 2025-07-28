# == Schema Information
#
# Table name: downloads
#
#  id                     :bigint           not null, primary key
#  download_category_id   :bigint           not null
#  title(名稱)            :string
#  title_en(英文名稱)     :string
#  status(狀態)           :string           default("published"), not null
#  en_status(英文狀態)    :string           default("hidden"), not null
#  translations           :jsonb
#  position(排列順序)     :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_downloads_on_download_category_id  (download_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (download_category_id => download_categories.id)
#
class Download < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
    published: 'published',
    hidden: 'hidden'
  }.freeze

  # == Extensions ===========================================================
  audited
  acts_as_list scope: [:download_category_id]
  include Contentable
  extend Mobility
  translates :desc

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en
  has_one_attached :file
  has_one_attached :file_en

  # == Relationships ========================================================
  belongs_to :download_category
  validates :position, uniqueness: { scope: :download_category }

  # == Validations ==========================================================
  validates :status, presence: true
  validates :title, presence: true, uniqueness: { scope: :download_category }
  validates :file, attached: true

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title title_en status en_status position)
  end

  # == Instance Methods =====================================================
end
