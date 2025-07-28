# == Schema Information
#
# Table name: figures
#
#  id                     :bigint           not null, primary key
#  position(排列順序)     :integer
#  translations           :jsonb
#  imageable_type         :string           not null
#  imageable_id(對象物件) :bigint           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_figures_on_imageable  (imageable_type,imageable_id)
#
class Figure < ApplicationRecord
  # == Constants ============================================================

  # == Extensions ===========================================================
  acts_as_list scope: %i(imageable_type imageable_id)
  include Mobility
  translates :alt

  # == Attributes ===========================================================
  has_one_attached :image

  # == Relationships ========================================================
  belongs_to :imageable, polymorphic: true

  # == Validations ==========================================================
  validates :image, attached: true

  # == Scopes ===============================================================
  default_scope { order(position: :asc) }

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(id imageable_id imageable_type position created_at updated_at)
  end

  # == Instance Methods =====================================================

end
