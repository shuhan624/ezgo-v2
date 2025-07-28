# == Schema Information
#
# Table name: menus
#
#  id                   :bigint           not null, primary key
#  parent_id(父節點)    :integer
#  position(排序)       :integer          not null
#  title(標題文字)      :string
#  title_en(英文標題)   :string
#  status(狀態)         :string           default("hidden"), not null
#  en_status(英文狀態)  :string           default("hidden"), not null
#  link(連結)           :string
#  link_en(英文連結)    :string
#  target(是否開新視窗) :boolean          default(FALSE), not null
#  lft                  :integer          not null
#  rgt                  :integer          not null
#  depth                :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_menus_on_lft        (lft)
#  index_menus_on_parent_id  (parent_id)
#  index_menus_on_rgt        (rgt)
#
class Menu < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
    published: 'published',
    hidden: 'hidden',
  }.freeze

  # == Extensions ===========================================================
  acts_as_nested_set order_column: :position
  acts_as_list scope: [:parent_id]
  audited

  # == Attributes ===========================================================
  enum :status, STATUS, prefix: :zh_tw
  enum :en_status, STATUS, prefix: :en

  # == Relationships ========================================================
  belongs_to :parent, class_name: 'Menu', optional: true
  has_many :children, -> { order(:position) }, class_name: 'Menu', foreign_key: :parent_id

  # == Validations ==========================================================
  validates :status, :en_status, presence: true
  validates :title, presence: true, if: -> { status == 'published' }
  validates :title_en, presence: true, if: -> { en_status == 'published' && parent_id.present? }
  # The position column is set after validations are called
  # 所以不要 validate position

  # == Scopes ===============================================================
  scope :publics, ->(locale) {
    if locale == :en
      where(en_status: 'published')
    else
      where(status: 'published')
    end
  }

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.header
    includes(:children).find_by(title_en: 'Header')
  end

  # == Instance Methods =====================================================

end
