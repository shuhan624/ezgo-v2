require 'rails_helper'

RSpec.describe "編輯單一最新消息文章頁面", type: :system do
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
      }
    })
    @no_permit_role = create(:role, permissions: {
      article: {
        index: true,
        show: true,
        edit: true,
      }
    })
    @no_edit_permit_role = create(:role, permissions: {
      article: {
        index: true,
        show: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, role: @no_permit_role)
    @no_edit_permissions_admin = create(:admin, role: @no_edit_permit_role)
  end

  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀
#

  context "編輯文章頁面 (edit)" do
    it "沒有 edit 權限者，不可以看到" do
      login_as(@no_edit_permissions_admin, scope: :admin)
      visit edit_admin_article_path(article)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 edit 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_article_path(article)
      expect(page).to have_content("編輯最新消息")
    end
  end

  context "按鈕區塊" do
    let(:edit_permission_role) { create(:role, permissions: {
      article: { index: true, edit: true, }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      article: { index: true, show: true, edit: true, destroy: true }
    }) }

    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit edit_admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit edit_admin_article_path(article)
        expected_content = find('.float-btns')
        expect(expected_content).to have_css('.btn-danger-light')
      end
    end
  end

#   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀            ▀▀▀▀▀▀▀▀▀▀   ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context '更新最新消息' do
    it "沒有 update 權限者，不可以更新" do
      login_as(@no_permissions_admin, scope: :admin)
      fill_in_data_on_article_form
      click_button("更新最新消息")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 update 權限者，可以更新" do
      login_as(@admin_has_permissions, scope: :admin)
      fill_in_data_on_article_form
      click_button("更新最新消息")
      expect(page).to have_content('新的標題')
      expect(page).to have_content('成功更新 最新消息')
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄         ▄  ▄▄       ▄▄  ▄▄        ▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌       ▐░▌▐░░▌     ▐░░▌▐░░▌      ▐░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌       ▐░▌▐░▌░▌   ▐░▐░▌▐░▌░▌     ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌▐░▌    ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌ ▐░▐░▌ ▐░▌▐░▌ ▐░▌   ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌  ▐░▌  ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌   ▀   ▐░▌▐░▌   ▐░▌ ▐░▌
#  ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌     ▐░▐░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌      ▐░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀        ▀▀
#

  context "最新消息編輯頁面中的欄位" do
    before { login_as(@admin_has_permissions, scope: :admin) }

    context "當文章類型為「文章內容」時" do
      it "可以看到中文的「HTML 內容編輯器」" do
        visit edit_admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('共用設定')

        within('fieldset.radio_buttons.article_post_type') do
          choose('文章內容', allow_label_click: true)
        end

        find('.tabs-group .tabs-btn').click_link('中文')
        expect(page).to have_css('.text.article_content')
        expect(page).not_to have_css('.string.article_source_link_zh_tw')
      end

      it "可以看到英文的「HTML 內容編輯器」" do
        visit edit_admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('共用設定')

        within('fieldset.radio_buttons.article_post_type') do
          choose('文章內容', allow_label_click: true)
        end

        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.text.article_content_en')
        expect(page).not_to have_css('.string.article_source_link_en')
      end
    end

    context "當文章類型為「外部連結」時" do
      it "可以看到中文的「連結」欄位" do
        visit edit_admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('共用設定')

        within('fieldset.radio_buttons.article_post_type') do
          choose('外部連結', allow_label_click: true)
        end

        find('.tabs-group .tabs-btn').click_link('中文')
        scroll_to(find('.string.article_source_link_zh_tw'))
        expect(page).to have_css('.string.article_source_link_zh_tw')
        expect(page).not_to have_css('.text.article_content')
      end

      it "可以看到英文的「連結」欄位" do
        visit edit_admin_article_path(article)
        find('.tabs-group .tabs-btn').click_link('共用設定')

        within('fieldset.radio_buttons.article_post_type') do
          choose('外部連結', allow_label_click: true)
        end

        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.string.article_source_link_en')
        expect(page).not_to have_css('.text.article_content_en')
      end
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
    article
    title = '新的標題'
    title_en = 'New Title'
    visit edit_admin_article_path(article)

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
