# == Schema Information
#
# Table name: documents
#
#  id                  :bigint           not null, primary key
#  attachable_type     :string
#  attachable_id       :bigint
#  title(標題)         :string
#  slug(slug)          :string
#  file_type(檔案類型) :string           default("file")
#  language(檔案語系)  :string
#  link(連結)          :string
#  spec(其他)          :jsonb
#  position(排列順序)  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_documents_on_attachable  (attachable_type,attachable_id)
#  index_documents_on_slug        (slug) UNIQUE
#
class Document < ApplicationRecord
  # == Constants ============================================================
  FILE_TYPE = {
    file: 'file', # 上傳檔案
    link: 'link', # 連結位置
  }.freeze

  LANGUAGE = {
    tw: 'tw', # 中文
    en: 'en', # 英文
  }.freeze

  
  # == Extensions ===========================================================
  acts_as_list scope: %i(attachable_type attachable_id language)
  include Contentable
  include Postable
  extend FriendlyId
  friendly_id :gen_slug, use: :slugged

  def gen_slug
    SecureRandom.alphanumeric(16).downcase
  end

  # == Attributes ===========================================================
  enum :file_type, FILE_TYPE
  enum :language, LANGUAGE
  has_one_attached :file

  # == Relationships ========================================================
  belongs_to :attachable, optional: true, polymorphic: true

  # == Validations ==========================================================
  validates :slug, uniqueness: true, presence: true
  validates :title, :file_type, :language, presence: true
  validate :document_file_not_empty
  validates :file,
            content_type: ['application/pdf'],
            size: { between: 1.kilobyte..15.megabytes, message: '檔案大小不得超過 15Mb' }

  def document_file_not_empty
    case file_type
    when "file"
      errors.add(:file, '不能為空白') if file.blank?
    when "link"
      errors.add(:link, '不能為空白') if link.blank?
    end
  end

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(title slug language file_type created_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(id attachable_id attachable_type position created_at updated_at)
  end

  # == Instance Methods =====================================================

end
