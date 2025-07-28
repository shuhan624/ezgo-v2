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
require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { create(:admin) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(admin).to be_valid
    end

    context "if cw_chief" do
      before { allow(subject).to receive(:cw_chief).and_return(true) }
      it { should_not validate_presence_of(:role) }
    end

    context "if NOT cw_chief" do
      before { allow(subject).to receive(:cw_chief).and_return(false) }
      it { should validate_presence_of(:role) }
    end

    context '帳號 Email' do
      # Email 格式驗證 https://ithelp.ithome.com.tw/articles/10094951

      it '為必填欄位' do
        admin = build(:admin, email: nil)
        expect(admin).not_to be_valid

        admin = build(:admin, email: '')
        expect(admin).not_to be_valid
      end

      it '不可以重複' do
        admin2 = build(:admin, email: admin.email)
        expect(admin2).not_to be_valid
      end

      it '必須要有一個「@」' do
        admin = build(:admin, email: 'abc.com')
        expect(admin).not_to be_valid
      end

      it '不可以有一個以上的「@」' do
        admin = build(:admin, email: 'abc@123@example.com')
        expect(admin).not_to be_valid
      end

      it '「@」前面一定要有「字母」或「數字」' do
        admin = build(:admin, email: '@example.com')
        expect(admin).not_to be_valid
      end
    end

    it '「帳號狀態 account active」' do
      admin = build(:admin, account_active: nil)
      expect(admin).not_to be_valid

      admin = build(:admin, account_active: '')
      expect(admin).not_to be_valid
    end
  end
end

