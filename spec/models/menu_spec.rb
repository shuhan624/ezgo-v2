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
require 'rails_helper'

RSpec.describe Menu, type: :model do
  subject { build(:menu) }
  let(:menu) { create(:menu) }

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(menu).to be_valid
    end

    context 'title validation' do
      it '中文 title validation' do
        menu = build(:menu, title: nil, status: 'published')
        expect(menu).not_to be_valid
      end

      it '英文 title validation' do
        menu = build(:menu, title_en: nil, en_status: 'published')
        expect(menu).not_to be_valid
      end
    end

    context 'status validation' do
      it 'status validation' do
        menu = build(:menu, status: nil)
        expect(menu).not_to be_valid
      end

      it 'en_status validation' do
        menu = build(:menu, en_status: nil)
        expect(menu).not_to be_valid
      end
    end
  end
end
