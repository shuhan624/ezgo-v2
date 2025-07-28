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
FactoryBot.define do
  factory :menu do
    parent { Menu.header }

    factory :tw_published_menu do
      title { FFaker::Lorem.characters.first(10) }
      status { 'published' }
    end

    factory :en_published_menu do
      title_en { FFaker::Lorem.characters.first(10) }
      en_status { 'published' }
    end
  end
end
