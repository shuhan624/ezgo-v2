# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id                       :bigint           not null, primary key
#  email(帳號)              :string           not null
#  name(姓名)               :string
#  cw_chief(前網帳號)       :boolean          default(FALSE)
#  role_id(角色)            :bigint
#  account_active(帳號狀態) :boolean          default(TRUE)
#  language(管理語系)       :jsonb
#  alt(照片描述)            :string
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  failed_attempts          :integer          default(0), not null
#  unlock_token             :string
#  locked_at                :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admins_on_role_id               (role_id)
#  index_admins_on_unlock_token          (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
class Admin < ApplicationRecord
  # == Constants ============================================================
  LANGUAGES = %i(tw en).freeze

  # == Extensions ===========================================================
  audited
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :timeoutable

  # == Attributes ===========================================================
  store_accessor :language, LANGUAGES

  # == Relationships ========================================================
  belongs_to :role, optional: true

  # == Validations ==========================================================
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } , uniqueness: true
  validates :role, presence: true, if: -> { cw_chief == false }
  validates :account_active, inclusion: { in: [true, false] }
  # validates :tw, :en, inclusion: [true, false]

  def active_for_authentication?
    super && account_active?
  end

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.ransackable_attributes(auth_object = nil)
    %w(email name role_id account_active)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
  def can?(action, resource)
    self.role.send("#{resource}_permissions")&.dig(action.to_s)&.to_s == 'true' if role.present?
  end

  def inactive_message
    account_active? ? super : :account_inactive
  end

  # for Devise no use email
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def cw_chief?
    cw_chief == true
  end
end
