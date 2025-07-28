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
require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(role).to be_valid
    end

    it { should validate_presence_of(:name) }
  end
end
