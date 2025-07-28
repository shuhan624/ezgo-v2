require "rails_helper"

RSpec.describe "中文版 - 全站設定", type: :system do
  before(:all) do
    @permit_role = create(:role, permissions: {
      setting: {
        index: true,
        edit: true,
        update: true,
      }
    })
    @permit_role_without_update = create(:role, permissions: {
      setting: {
        index: true,
        edit: true,
      }
    })

    @admin_has_permissions = create(:admin, role: @permit_role)
    @no_permissions_admin = create(:admin, :no_permissions)
    @admin_without_update_permissions = create(:admin, role: @permit_role_without_update)
  end


  after(:all) do
    Admin.delete_all
    Role.delete_all
  end

  let(:title) { FFaker::LoremCN.paragraph.first(10).strip }
  let(:description) { FFaker::LoremCN.paragraph.first(20).strip }

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
  context "編輯全站設定 (edit)" do
    it "沒有 edit 權限者，不可以看到" do
      login_as(@no_permissions_admin, scope: :admin)
      site_title = Setting.find_by(name: 'site_title')
      visit edit_admin_setting_path(site_title)
      expect(page).to have_content("無權進行此操作")
    end

    it "有 edit 權限者，可以到達" do
      login_as(@admin_has_permissions, scope: :admin)
      site_title = Setting.find_by(name: 'site_title')
      visit edit_admin_setting_path(site_title)
      expect(page).to have_content("編輯全站設定")
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
  context '更新全站設定' do
    it "沒有 update 權限者，不可以更新" do
      login_as(@admin_without_update_permissions, scope: :admin)
      site_title = Setting.find_by(name: 'site_title')
      visit edit_admin_setting_path(site_title)
      # 清空 input 欄位
      fill_in("setting[content_zh_tw]", with: '')
      fill_in("setting[content_zh_tw]", with: title)
      click_button "更新"
      expect(page).to have_content("無權進行此操作")
    end

    it "有 update 權限者，可以更新" do
      login_as(@admin_has_permissions, scope: :admin)
      site_title = Setting.find_by(name: 'site_title')
      visit edit_admin_setting_path(site_title)
      # 清空 input 欄位
      fill_in("setting[content_zh_tw]", with: '')
      fill_in("setting[content_zh_tw]", with: title)
      click_button "更新"
      expect(page).to have_content('成功更新 全站設定')
      expect(page).to have_content(title)
    end
  end

  context '更新全站設定內容' do
    before(:each) { login_as(@admin_has_permissions, scope: :admin) }
    context '網站資訊' do
      context '網站名稱' do
        it '更新內容後，前台頁面會顯示 頁面名稱 與 新的網站名稱' do
          about_page = create(:custom_page, slug: 'about')
          site_title = Setting.find_by(name: 'site_title')
          visit edit_admin_setting_path(site_title)
          # 清空 input 欄位
          fill_in("setting[content_zh_tw]", with: '')
          fill_in("setting[content_zh_tw]", with: title)
          click_button "更新"

          visit 'http://localhost/about'
          # 頁面標題: "頁面名稱 | 新的網站名稱"
          expect(page.title).to eq("#{about_page.title} | #{title}")
        end

        it '更新內容後，website_schema 會顯示新的網站名稱' do
          site_title = Setting.find_by(name: 'site_title')
          visit edit_admin_setting_path(site_title)
          # 清空 input 欄位
          fill_in("setting[content_zh_tw]", with: '')
          fill_in("setting[content_zh_tw]", with: title)
          click_button "更新"

          visit 'http://localhost'
          schema_script = find('script[type="application/ld+json"]', visible: false)
          schema_data = JSON.parse(schema_script.text(:all))
          expect(schema_data['name']).to eq(title)
          expect(schema_data['alternateName']).to eq(title)
        end

        it '更新內容後，後台會顯示新的內容' do
          site_title = Setting.find_by(name: 'site_title')
          visit edit_admin_setting_path(site_title)
          fill_in("setting[content_zh_tw]", with: '')
          fill_in("setting[content_zh_tw]", with: title)
          click_button "更新"

          expect(page.title).to eq("管理後台 - #{title}")
        end
      end

      context '版權宣告' do
        it '更新內容後，前台會顯示新的版權宣告名稱' do
          copyright = Setting.find_by(name: 'copyright')
          title = FFaker::Lorem.paragraph.first(10)

          visit edit_admin_setting_path(copyright)
          fill_in("setting[content_zh_tw]", with: title)
          click_button "更新"

          visit 'http://localhost'
          element = find('.footer-other-info')
          expect(element).to have_content(title)
        end

        it '更新內容後，後台會顯示新的版權宣告名稱' do
          copyright = Setting.find_by(name: 'copyright')
          title = FFaker::Lorem.paragraph.first(10)

          visit edit_admin_setting_path(copyright)
          fill_in("setting[content_zh_tw]", with: title)
          click_button "更新"

          find('.admin-header .header-user').click
          find('.admin-logout').click
          element = find('.copyright')
          expect(element).to have_content(title)
        end
      end

      it '更新後台logo後，後台會顯示新的logo' do
        admin_logo = Setting.find_by(name: 'admin_logo')
        visit edit_admin_setting_path(admin_logo)

        attach_file('setting[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
        click_button "更新"

        element = find('#leftsidebar .header-logo img')
        expect(element[:src]).to include('image.jpg')
      end

      it '更新前台logo後，前台會顯示新的logo' do
        site_logo = Setting.find_by(name: 'logo')
        visit edit_admin_setting_path(site_logo)
        attach_file('setting[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
        click_button "更新"

        visit 'http://localhost'
        element = find('.header-logo img')
        expect(element[:src]).to include('image.jpg')
      end

      context '網站圖示' do
        it '更新圖示後，前台會顯示新的圖示' do
          favicon = Setting.find_by(name: 'favicon')
          visit edit_admin_setting_path(favicon)
          attach_file('setting[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
          click_button "更新"

          visit 'http://localhost'
          element = find("link[rel='icon']", visible: false)
          expect(element[:href]).to include('image.jpg')
        end

        it '更新圖示後，後台會顯示新的圖示' do
          favicon = Setting.find_by(name: 'favicon')
          visit edit_admin_setting_path(favicon)
          attach_file('setting[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
          click_button "更新"

          element = find("link[rel='icon']", visible: false)
          expect(element[:href]).to include('image.jpg')
        end
      end
    end

    context 'SEO & 行銷管理' do
      it '更新 Meta標題 後，前台首頁會顯示新的 Meta標題' do
        meta_title = Setting.find_by(name: 'meta_title')
        visit edit_admin_setting_path(meta_title)
        fill_in("setting[content_zh_tw]", with: '')
        fill_in("setting[content_zh_tw]", with: title)
        click_button "更新"

        visit 'http://localhost'
        expect(page.title).to eq(title)
      end

      it '更新 Meta關鍵字 後，前台會顯示新的 Meta關鍵字' do
        meta_keywords = Setting.find_by(name: 'meta_keywords')
        visit edit_admin_setting_path(meta_keywords)
        fill_in("setting[content_zh_tw]", with: '')
        fill_in("setting[content_zh_tw]", with: title)
        click_button "更新"

        visit 'http://localhost'
        element = find("meta[name='keywords']", visible: false)
        expect(element[:content]).to eq(title)
      end

      it '更新 Meta描述 後，前台會顯示新的 Meta描述' do
        meta_desc = Setting.find_by(name: 'meta_desc')
        visit edit_admin_setting_path(meta_desc)
        fill_in("setting[content_zh_tw]", with: '')
        fill_in("setting[content_zh_tw]", with: description)
        click_button "更新"

        visit 'http://localhost'
        element = find("meta[name='description']", visible: false)
        expect(element[:content]).to eq(description)
      end

      it '更新 OG標題 後，前台會顯示新的 OG標題' do
        og_title = Setting.find_by(name: 'og_title')
        visit edit_admin_setting_path(og_title)
        fill_in("setting[content_zh_tw]", with: '')
        fill_in("setting[content_zh_tw]", with: title)
        click_button "更新"

        visit 'http://localhost'
        element = find("meta[property='og:title']", visible: false)
        expect(element[:content]).to eq(title)
      end

      it '更新 OG描述 後，前台會顯示新的 OG描述' do
        og_desc = Setting.find_by(name: 'og_desc')
        visit edit_admin_setting_path(og_desc)
        fill_in("setting[content_zh_tw]", with: '')
        fill_in("setting[content_zh_tw]", with: description)
        click_button "更新"

        visit 'http://localhost'
        element = find("meta[property='og:description']", visible: false)
        expect(element[:content]).to eq(description)
      end

      it '更新 OG_imgae 後，前台會顯示新的 OG_imgae' do
        og_image = Setting.find_by(name: 'og_image')
        visit edit_admin_setting_path(og_image)
        attach_file('setting[image]', "#{Rails.root}/spec/fixtures/image.jpg", make_visible: true)
        click_button "更新"

        visit 'http://localhost'
        element = find("meta[property='og:image']", visible: false)
        expect(element[:content]).to include('image.jpg')
      end
    end

    context '社群連結' do
      let!(:contact_page) { create(:custom_page, slug: 'contact') }
      context '狀態為公開時，前台可以看得到社群連結' do
        it 'Facebook' do
          facebook = Setting.find_by(name: 'facebook')
          visit edit_admin_setting_path(facebook)
          fill_in("setting[content_zh_tw]", with: 'https://www.facebook.com/profile.php?id=100092367793258&mibextid=LQQJ4d')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.facebook.com/profile.php?id=100092367793258&mibextid=LQQJ4d"]')
        end

        it 'Instagram' do
          instagram = Setting.find_by(name: 'instagram')
          visit edit_admin_setting_path(instagram)
          fill_in("setting[content_zh_tw]", with: 'https://www.instagram.com/google')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.instagram.com/google"]')
        end

        it 'Line' do
          line = Setting.find_by(name: 'line')
          visit edit_admin_setting_path(line)
          fill_in("setting[content_zh_tw]", with: 'https://line.me/R/ti/p/@878zxxhh?oat_content=url&ts=10091718')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://line.me/R/ti/p/@878zxxhh?oat_content=url&ts=10091718"]')
        end

        it 'Youtube' do
          youtube = Setting.find_by(name: 'youtube')
          visit edit_admin_setting_path(youtube)
          fill_in("setting[content_zh_tw]", with: 'https://www.youtube.com/@cwcianwang')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.youtube.com/@cwcianwang"]')
        end
      end

      context '狀態為公開時，website_schema 會顯示新的社群連結' do
        xit 'Facebook' do
        end

        xit 'Instagram' do
        end

        xit 'Line' do
        end

        xit 'Youtube' do
        end
      end

      context '狀態為隱藏時，前台不會看到社群連結' do
        it 'Facebook' do
          facebook = Setting.find_by(name: 'facebook')
          visit edit_admin_setting_path(facebook)
          fill_in("setting[content_zh_tw]", with: 'https://www.facebook.com/profile.php?id=100092367793258&mibextid=LQQJ4d')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('隱藏', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).not_to have_css('a[href="https://www.facebook.com/profile.php?id=100092367793258&mibextid=LQQJ4d"]')
        end

        it 'Instagram' do
          instagram = Setting.find_by(name: 'instagram')
          visit edit_admin_setting_path(instagram)
          fill_in("setting[content_zh_tw]", with: 'https://www.instagram.com/google')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('隱藏', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).not_to have_css('a[href="https://www.instagram.com/google"]')
        end

        it 'Line' do
          line = Setting.find_by(name: 'line')
          visit edit_admin_setting_path(line)
          fill_in("setting[content_zh_tw]", with: 'https://line.me/R/ti/p/@878zxxhh?oat_content=url&ts=10091718')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('隱藏', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).not_to have_css('a[href="https://line.me/R/ti/p/@878zxxhh?oat_content=url&ts=10091718"]')
        end

        it 'Youtube' do
          youtube = Setting.find_by(name: 'youtube')
          visit edit_admin_setting_path(youtube)
          fill_in("setting[content_zh_tw]", with: 'https://www.youtube.com/@cwcianwang')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('隱藏', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).not_to have_css('a[href="https://www.youtube.com/@cwcianwang"]')
        end
      end

      context '更新社群連結後，前台會顯示新的社群連結' do
        it 'Facebook' do
          facebook = Setting.find_by(name: 'facebook')
          visit edit_admin_setting_path(facebook)
          fill_in("setting[content_zh_tw]", with: 'https://www.facebook.com/cwcianwang/')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.facebook.com/cwcianwang/"]')
        end

        it 'Instagram' do
          instagram = Setting.find_by(name: 'instagram')
          visit edit_admin_setting_path(instagram)
          fill_in("setting[content_zh_tw]", with: 'https://www.instagram.com/cwcianwang/')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.instagram.com/cwcianwang/"]')
        end

        it 'Line' do
          line = Setting.find_by(name: 'line')
          visit edit_admin_setting_path(line)
          fill_in("setting[content_zh_tw]", with: 'https://line.me/R/ti/p/@cwcianwang')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://line.me/R/ti/p/@cwcianwang"]')
        end

        it 'Youtube' do
          youtube = Setting.find_by(name: 'youtube')
          visit edit_admin_setting_path(youtube)
          fill_in("setting[content_zh_tw]", with: 'https://www.youtube.com/@cwcianwang')
          within('fieldset.radio_buttons.setting_status_zh_tw', match: :first) do
            choose('公開', allow_label_click: true)
          end
          click_button "更新"

          visit 'http://localhost/contact'
          element = find('.social-icons')
          expect(element).to have_css('a[href="https://www.youtube.com/@cwcianwang"]')
        end
      end
    end

    context '其他設定' do
      xit '更新 首頁彈跳廣告 後，前台會顯示新的 首頁彈跳廣告' do
        popup = Setting.find_by(name: 'popup_homepage')
        visit edit_admin_setting_path(popup)
        content = FFaker::HTMLIpsum.fancy_string
        fill_in_editor('setting_content_zh_tw', with: content)
        click_button "更新"

        visit 'http://localhost'
        scroll_to(find('.index-popup'), align: :top)
        expect(page).to have_content(content)
      end
    end
  end
end
