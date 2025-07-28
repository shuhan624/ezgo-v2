# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email(帳號)                 :string
#  name(姓名)                  :string
#  phone(電話)                 :string
#  role(會員級別)              :string           default("regular")
#  account_active(帳號狀態)    :boolean          default(TRUE)
#  country(國家)               :string
#  zip_code(郵遞區號)          :string
#  city(縣市)                  :string
#  dist(地區)                  :string
#  address(地址)               :string
#  line_uid(LINE UID)          :string
#  line_avatar(LINE 大頭貼)    :string
#  line_auth_at(LINE 註冊日期) :datetime
#  note(備註)                  :text
#  admin_note(後台備註)        :text
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  confirmation_token          :string
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  encrypted_password          :string           default(""), not null
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0), not null
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :inet
#  last_sign_in_ip             :inet
#  failed_attempts             :integer          default(0), not null
#  unlock_token                :string
#  locked_at                   :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_line_uid              (line_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  # == Constants ============================================================
  ROLES = {
        vip: 'vip',     # VIP
    regular: 'regular', # 一般會員
  }.freeze

  # == Attributes ===========================================================
  enum :role, ROLES

  # == Extensions ===========================================================
  audited
  # Include default devise modules. Others available are:
  #
  devise :database_authenticatable, :registerable, :recoverable, :confirmable, :lockable, :rememberable, :validatable, :trackable, :timeoutable, :omniauthable, omniauth_providers: [:line]

  # == Relationships ========================================================
  has_many :orders, dependent: :nullify
  has_many :valid_orders, -> { where.not(status: 'order_init') }, class_name: 'Order'
  has_many :visits, class_name: "Ahoy::Visit"

  # == Validations ==========================================================
  validates :role, presence: true
  validates :email, presence: true, uniqueness: true, if: -> { line_uid.blank? }
  validates :line_uid, allow_nil: true, uniqueness: true
  validates :account_active, inclusion: { in: [true, false] }
  validates_format_of :zip_code, with: /\A\d+\z/, allow_blank: true

  def active_for_authentication?
    super && account_active?
  end

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email) if auth.info.email.present?
    user ||= find_or_initialize_by(line_uid: auth.uid)
    user.assign_attributes(
      line_uid: auth.uid,
      line_name: auth.info.name,
      line_avatar: auth.info.image,
      email: auth.info.email
    )
    user.line_auth_at ||= DateTime.current
    user.skip_confirmation! if user.confirmed_at.blank?
    user.save
    user
  end

  def self.ransackable_attributes(auth_object = nil)
    %w(email name phone role account_active country zip_code city dist address created_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
  def inactive_message
    account_active? ? super : :account_inactive
  end

  def email_required?
    self.line_uid? ? false : super
  end

  def password_required?
    self.line_uid? ? false : super
  end

  def line?
    self.line_uid.present?
  end

  def unfinished_order
    self.orders.where(status: 'order_init').order(:id).last
  end
end
