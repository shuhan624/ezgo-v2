# == Schema Information
#
# Table name: contacts
#
#  id                :bigint           not null, primary key
#  name(姓名)        :string           not null
#  email(電子郵件)   :string
#  phone(聯絡電話)   :string           not null
#  company(公司名稱) :string
#  address(聯絡地址) :string
#  content(詢問內容) :text
#  admin_note(備註)  :text
#  status(狀態)      :string           default("new_case"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_contacts_on_email  (email)
#  index_contacts_on_name   (name)
#  index_contacts_on_phone  (phone)
#
class Contact < ApplicationRecord
  # == Constants ============================================================
  STATUS = {
      new_case: 'new_case',
    processing: 'processing',
      finished: 'finished'
  }.freeze

  # == Extensions ===========================================================
  audited

  # == Attributes ===========================================================
  enum :status, STATUS

  # == Relationships ========================================================

  # == Validations ==========================================================
  validates :name, :email, :phone, :status, presence: true

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  def self.ransackable_attributes(auth_object = nil)
    %w(name email phone address status updated_at created_at)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(audits)
  end

  # == Instance Methods =====================================================
end
