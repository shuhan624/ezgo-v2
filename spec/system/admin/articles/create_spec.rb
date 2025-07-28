require 'rails_helper'

RSpec.describe "新增單一最新消息", type: :system do
  let(:article_category) { create(:article_category) }
  let(:article) { create(:article) }
  let(:articles) { create_list(:article, 5) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      article: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
        preview: true,
        show_tags: true
      }
    })
    @no_create_permit_role = create(:role, permissions: {
      article: {
        index: true,
        show: true,
        new: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_create_permissions_admin = create(:admin, role: @no_create_permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄
#  ▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
#  ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
#  ▐░▌▐░▌    ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░▌ ▐░▌   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌   ▄   ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌   ▐░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌ ▐░▌░▌ ▐░▌
#  ▐░▌    ▐░▌▐░▌▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#  ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌░▌   ▐░▐░▌
#  ▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀       ▀▀
#

  context "新增文章頁面 (new)" do
    it "沒有 new 權限者，不能到達" do
      login_as(@no_permissions_admin, scope: :admin)
      visit new_admin_article_path
      expect(page).to have_content("無權進行此操作")
    end

    it "有 new 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit new_admin_article_path
      expect(page).to have_content("新增最新消息")
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "新增文章 (Create)" do
    it "沒有 create 權限者，不能新增" do
      login_as(@no_create_permissions_admin, scope: :admin)
      fill_in_data_on_article_form
      click_button("建立最新消息")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 create 權限者，可以新增" do
      login_as(@admin_has_permissions, scope: :admin)
      before_count = Article.count
      fill_in_data_on_article_form
      click_button("建立最新消息")

      expected_content = find('section.content')
      title = Article.order(created_at: :desc).first.title
      after_count = Article.count

      expect(page).to have_content('成功新增 最新消息')
      expect(expected_content).to have_content(title)
      expect(after_count).to eq(before_count + 1)
    end
  end

#   ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄
#  ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#  ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌▐░▌ ▐░▌▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀
#

  def fill_in_data_on_article_form
    article_category
    title = FFaker::Lorem.characters.first(20)
    title_en = FFaker::Lorem.characters.first(20)
    visit new_admin_article_path

    find('.tabs-group .tabs-btn').click_link('共用設定')
    fill_in("article[slug]", with: (FFaker::Internet.slug(nil, '-') + FFaker::Lorem.characters.first(5)))

    within('fieldset.radio_buttons.article_post_type') do
      choose('文章內容', allow_label_click: true)
    end

    within('fieldset.radio_buttons.article_default_category') do
      choose(article_category.name, allow_label_click: true)
    end

    check(article_category.name, allow_label_click: true) # 因為前端用了 BootStrap, 隱藏真正的 checkbox

    select('不設定為「精選」項目', from: 'article_featured', visible: false)
    select('不設定為「置頂」項目', from: 'article_top', visible: false)

    find('.tabs-group .tabs-btn').click_link('中文')
    fill_in("article[title]", with: title)
    fill_in("article[published_at]", with: '')
    fill_in("article[published_at]", with: Time.current.strftime('%F %R'))
    fill_in("article[expired_at]", with: '')
    fill_in("article[expired_at]", with: (Time.current + 10.days).strftime('%F %R'))
    fill_in("article[alt_zh_tw]", with: FFaker::Lorem.characters.first(10))
    fill_in("article[abstract_zh_tw]", with: FFaker::Book.description)
    fill_in_editor('article_content', with: FFaker::HTMLIpsum.body)
    attach_file('article[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)

    find('.tabs-group .tabs-btn').click_link('英文')
    fill_in("article[title_en]", with: title_en)
    fill_in("article[published_at_en]", with: '')
    fill_in("article[published_at_en]", with: Time.current.strftime('%F %R'))
    fill_in("article[expired_at_en]", with: '')
    fill_in("article[expired_at_en]", with: (Time.current + 10.days).strftime('%F %R'))
    fill_in("article[alt_en]", with: FFaker::Lorem.characters.first(10))
    fill_in("article[abstract_en]", with: FFaker::Book.description)
    fill_in_editor('article_content_en', with: FFaker::HTMLIpsum.body)
    attach_file('article[image_en]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)

    find('.tabs-group .tabs-btn').click_link('SEO')
    fill_in('article[seo_attributes][meta_title_zh_tw]', with: FFaker::Lorem.characters.first(10))
    fill_in('article[seo_attributes][meta_keywords_zh_tw]', with: FFaker::Lorem.word)
    fill_in('article[seo_attributes][meta_desc_zh_tw]', with: FFaker::Book.description)
    fill_in('article[seo_attributes][og_title_zh_tw]', with: FFaker::Lorem.characters.first(10))
    fill_in('article[seo_attributes][og_desc_zh_tw]', with: FFaker::Book.description)
    attach_file('article[seo_attributes][og_image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
    attach_file('article[seo_attributes][og_image_en]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)

    scroll_to(find('.form-actions'), align: :top)
  end
end
