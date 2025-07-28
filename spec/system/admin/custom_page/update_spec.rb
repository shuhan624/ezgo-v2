require 'rails_helper'

RSpec.describe "編輯單一頁面管理", type: :system do
  let(:custom_page) { create(:custom_page) }

  before(:all) do
    @permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        new: true,
        create: true,
        edit: true,
        update: true,
      }
    })
    @no_permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
        edit: true,
      }
    })

    @no_edit_permit_role = create(:role, permissions: {
      custom_page: {
        index: true,
        show: true,
      }
    })

    @cw_admin = create(:cw_chief)
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

  context "編輯頁面管理 (edit)" do
    it "沒有 edit 權限者，不可以看到" do
      login_as(@no_edit_permissions_admin, scope: :admin)
      visit edit_admin_custom_page_path(custom_page)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 edit 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      visit edit_admin_custom_page_path(custom_page)
      expect(page).to have_content("編輯頁面管理")
    end
  end

  context "按鈕區塊" do
    let(:edit_permission_role) { create(:role, permissions: {
      custom_page: { index: true, edit: true, }
    }) }

    let(:show_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, edit: true }
    }) }

    let(:destroy_permission_role) { create(:role, permissions: {
      custom_page: { index: true, show: true, edit: true, destroy: true }
    }) }

    let(:edit_permission_admin) { create(:admin, role: edit_permission_role) }
    let(:show_permission_admin) { create(:admin, role: show_permission_role) }
    let(:destroy_permission_admin) { create(:admin, role: destroy_permission_role) }

    context "詳細按鈕 (show)" do
      it "沒有 show 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_content(I18n.t('btn.show'))
      end

      it "有 show 權限者，可以看到" do
        login_as(show_permission_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).to have_content(I18n.t('btn.show'))
      end
    end

    context "刪除按鈕 (destroy)" do
      it "沒有 destroy 權限者，不可以看到" do
        login_as(edit_permission_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expected_content = find('.float-btns')
        expect(expected_content).not_to have_css('.btn-danger-light')
      end

      it "有 destroy 權限者，可以看到" do
        login_as(destroy_permission_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
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

  context '更新頁面管理' do
    it "沒有 update 權限者，不可以更新" do
      login_as(@no_permissions_admin, scope: :admin)
      update_data_on_custom_page_form
      click_button("更新頁面管理")
      expect(page).to have_content("無權進行此操作")
    end

    it "有 update 權限者，可以更新" do
      login_as(@admin_has_permissions, scope: :admin)
      update_data_on_custom_page_form
      click_button("更新頁面管理")
      find('.tabs-group .tabs-btn').click_link('中文')
      expect(page).to have_content('新的標題')
      expect(page).to have_content('成功更新 頁面管理')
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

  context "slug 欄位" do
    context "預設頁面" do
      let(:custom_page) { create(:custom_page, :default_page) }
      it "前網管理員 可以看到 slug 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_field('custom_page[slug]')
      end

      it "非前網管理員 看不到 slug 欄位" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_field('custom_page[slug]')
      end
    end

    context "非預設頁面" do
      it "前網管理員 可以看到 slug 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_field('custom_page[slug]')
      end

      it "非前網管理員 可以看到 slug 欄位" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_field('custom_page[slug]')
      end
    end
  end

  context "custom_type 欄位" do
    context "預設頁面" do
      it "前網管理員 可以看到 custom_type 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('fieldset.radio_buttons.custom_page_custom_type')
      end

      it "非前網管理員 看不到 custom_type 欄位" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_css('fieldset.radio_buttons.custom_page_custom_type')
      end
    end

    context "非預設頁面" do
      let(:custom_page) { create(:custom_page, :non_default_page) }
      it "前網管理員 可以看到 custom_type 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('fieldset.radio_buttons.custom_page_custom_type')
      end

      it "非前網管理員 不能看到 custom_type 欄位，custom_type 為預設值 info" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_css('fieldset.radio_buttons.custom_page_custom_type')
        expect(custom_page.custom_type).to eq('info')
      end
    end
  end

  context "status 欄位" do
    context "預設頁面" do
      let(:custom_page) { create(:custom_page, :default_page) }
      it "前網管理員 可以看到 status 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('fieldset.radio_buttons.custom_page_status')
      end

      it "非前網管理員 看不到 status 欄位" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_css('fieldset.radio_buttons.custom_page_status')
      end

      it "status 為預設值 published" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(custom_page.status).to eq('published')
      end
    end

    context "非預設頁面" do
      let(:custom_page) { create(:custom_page, :non_default_page) }
      it "前網管理員 可以看到 status 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('fieldset.radio_buttons.custom_page_status')
      end
    end
  end

  context "en_status 欄位" do
    context "預設頁面" do
      let(:custom_page) { create(:custom_page, :default_page) }
      it "前網管理員 可以看到 en_status 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('fieldset.radio_buttons.custom_page_en_status')
      end

      it "非前網管理員 看不到 en_status 欄位" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).not_to have_css('fieldset.radio_buttons.custom_page_en_status')
      end

      it "en_status 為預設值 published" do
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(custom_page.en_status).to eq('published')
      end
    end
  end

  context "content 欄位" do
    context "預設頁面" do
      it "前網管理員，更新 custom_type 為 info 時，可以看到 content 欄位" do
        custom_page = create(:custom_page, :default_page, :design)
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        within('fieldset.radio_buttons.custom_page_custom_type') do
          choose('頁面管理內容', allow_label_click: true)
        end
        expect(page).to have_css('.text.custom_page_content')
      end

      it "非前網管理員，custom_type 為 info 時，可以看到 content 欄位" do
        custom_page = create(:custom_page, :default_page, :info)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('.text.custom_page_content')
      end

      it "非前網管理員，custom_type 不為 info 時，不能看到 content 欄位" do
        custom_page = create(:custom_page, :default_page, :design)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).not_to have_css('.text.custom_page_content')
      end
    end

    context "非預設頁面" do
      it "前網管理員 可以看到 content 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('.text.custom_page_content')
      end

      it "非前網管理員，可以看到 content 欄位" do
        custom_page = create(:custom_page, :non_default_page)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        expect(page).to have_css('.text.custom_page_content')
      end
    end
  end

  context "content_en 欄位" do
    context "預設頁面" do
      it "前網管理員，更新 custom_type 為 info 時，可以看到 content_en 欄位" do
        custom_page = create(:custom_page, :default_page, :design)
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        within('fieldset.radio_buttons.custom_page_custom_type') do
          choose('頁面管理內容', allow_label_click: true)
        end
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.text.custom_page_content_en')
      end

      it "非前網管理員，custom_type 為 info 時，可以看到 content_en 欄位" do
        custom_page = create(:custom_page, :default_page, :info)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.text.custom_page_content_en')
      end

      it "非前網管理員，custom_type 不為 info 時，不能看到 content_en 欄位" do
        custom_page = create(:custom_page, :default_page, :design)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).not_to have_css('.text.custom_page_content_en')
      end
    end

    context "非預設頁面" do
      it "前網管理員 可以看到 content_en 欄位" do
        login_as(@cw_admin, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.text.custom_page_content_en')
      end

      it "非前網管理員，可以看到 content_en 欄位" do
        custom_page = create(:custom_page, :non_default_page)
        login_as(@admin_has_permissions, scope: :admin)
        visit edit_admin_custom_page_path(custom_page)
        find('.tabs-group .tabs-btn').click_link('英文')
        expect(page).to have_css('.text.custom_page_content_en')
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

  def update_data_on_custom_page_form
    custom_page
    title = '新的標題'
    title_en = 'new title'
    content = FFaker::Lorem.characters.first(20)
    content_en = FFaker::Lorem.characters.first(20)
    visit edit_admin_custom_page_path(custom_page)

    find('.tabs-group .tabs-btn').click_link('中文')
    fill_in("custom_page[title]", with: title)
    within('fieldset.radio_buttons.custom_page_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in_editor('custom_page_content', with: content)

    find('.tabs-group .tabs-btn').click_link('英文')
    fill_in("custom_page[title_en]", with: title_en)
    within('fieldset.radio_buttons.custom_page_en_status') do
      choose('公開', allow_label_click: true)
    end
    fill_in_editor('custom_page_content_en', with: content_en)

    scroll_to(find('.form-actions'), align: :top)
  end
end
