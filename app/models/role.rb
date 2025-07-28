# == Schema Information
#
# Table name: roles
#
#  id                    :bigint           not null, primary key
#  name(名稱)            :string           not null
#  permissions(權限設定) :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Role < ApplicationRecord
  # 讀取所有的 Models, 轉換成 Symbol 並排除不需要的 Models
  def self.default_permissions
    Rails.autoloaders.main.eager_load_dir("#{Rails.root}/app/models")
    exclusion = %w(OrderItem ProductCategory ProductHistory Seo Figure Package Role Ahoy::Event Ahoy::Visit)
    models = ApplicationRecord.descendants.collect(&:name).excluding(exclusion)
    models.map { |klass| [klass.underscore.to_sym, klass] }.to_h.merge(dashboard: 'headless')
  end

  # == Constants ============================================================
  PERMISSIONS = self.default_permissions.keys.freeze

  # == Extensions ===========================================================

  # == Attributes ===========================================================
  store_accessor :permissions, PERMISSIONS, suffix: true

  # == Relationships ========================================================
  has_many :admins, dependent: :nullify

  # == Validations ==========================================================
  validates :name, presence: true

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
end
