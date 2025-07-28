require 'rails_helper'

RSpec.describe "中文版 - 里程碑頁面", type: :system do
  let(:milestone) { create(:milestone) }
  let(:milestones_page) { create(:custom_page, slug: 'milestones') }
  let(:milestones_page_with_seo) { create(:custom_page, :with_seo, slug: 'milestones') }

#   ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀
#  ▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌       ▐░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀
#

  context "主選單語系切換" do
    it '當游標滑入語系切換選單「English」並點選時，可以切換到英文版頁面' do
      milestones_page
      visit milestones_path
      find('.lang-switch-group').click
      find('.dropdown-list-item', text: 'English').click
      expected_content = find('h1')
      expect(expected_content).to have_content(milestones_page.title_en)
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄
#  ▐░░░░░░░░░░░▌▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌
#  ▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░▌
#  ▐░░░░░░░░░░░▌▐░▌          ▐░▌
#  ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░▌          ▐░▌
#  ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#   ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀
#

  context "里程碑頁面" do
    context "麵包屑" do
      xit "可以看到麵包屑第一層為「首頁」，並有連結可到中文首頁" do
        milestones_page
        visit milestones_path
        expected_content = find('.breadcrumb-item', text: '首頁')
        expect(expected_content).to have_link('首頁', href: root_path)
      end

      it "可以看到麵包屑顯示為「關於我們」" do
        milestones_page = create(:custom_page, slug: 'milestones', title: '里程碑')
        visit milestones_path
        breadcrumb_items = all('.breadcrumb-item')

        # 預期的麵包屑順序
        expected_breadcrumbs = ['關於我們']

        breadcrumb_items.each_with_index do |item, index|
          expect(item.text).to eq(expected_breadcrumbs[index])
        end
      end
    end

    it "有「里程碑」自訂頁面時，可以看到自訂頁面「標題」，且為「H1」" do
      milestones_page
      visit milestones_path
      expected_content = find('h1')
      expect(expected_content).to have_content(milestones_page.title)
    end

    it "沒有「里程碑」自訂頁面時，可以看到「里程碑」為標題，且為「H1」" do
      visit milestones_path
      expected_content = find('h1')
      expect(expected_content).to have_text('里程碑')
    end

    context "Meta Data" do
      context "有「里程碑」自訂頁面" do
        context "Meta Title" do
          it "當有輸入時，顯示自訂 Meta Title" do
            milestones_page_with_seo
            site_title = Setting.find_by(name: 'site_title').content
            visit milestones_path
            expect(page).to have_title("#{milestones_page_with_seo.meta_title} | #{site_title}", exact: true)
          end

          it "當未輸入時，顯示自訂頁面的「標題」" do
            milestones_page
            site_title = Setting.find_by(name: 'site_title').content
            visit milestones_path
            expect(page).to have_title("#{milestones_page.title} | #{site_title}", exact: true)
          end
        end

        context "Meta Keywords" do
          it "當有輸入時，顯示自訂 Meta Keywords" do
            milestones_page_with_seo
            visit milestones_path
            expect(page).to have_meta(:keywords, milestones_page_with_seo.meta_keywords)
          end

          it "當未輸入時，顯示全站設定的 Meta Keywords" do
            milestones_page
            default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
            visit milestones_path
            expect(page).to have_meta(:keywords, default_meta_keywords)
          end
        end

        context "Meta Description" do
          it "當有輸入時，顯示自訂 Meta Description" do
            milestones_page_with_seo
            visit milestones_path
            expect(page).to have_meta(:description, milestones_page_with_seo.meta_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            milestones_page
            default_meta_desc = Setting.find_by(name: 'meta_desc').content
            visit milestones_path
            expect(page).to have_meta(:description, default_meta_desc)
          end
        end

        context "OG Title" do
          it "當有輸入時，顯示自訂 OG Title" do
            milestones_page_with_seo
            visit milestones_path
            expect(page).to have_og_meta(:title, milestones_page_with_seo.og_title)
          end

          it "當未輸入時，顯示全站設定的 OG Title" do
            milestones_page
            default_meta_desc = Setting.find_by(name: 'og_title').content
            visit milestones_path
            expect(page).to have_og_meta(:title, default_meta_desc)
          end
        end

        context "OG Description" do
          it "當有輸入時，顯示自訂 OG Description" do
            milestones_page_with_seo
            visit milestones_path
            expect(page).to have_og_meta(:description, milestones_page_with_seo.og_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            milestones_page
            default_meta_desc = Setting.find_by(name: 'og_desc').content
            visit milestones_path
            expect(page).to have_og_meta(:description, default_meta_desc)
          end
        end
      end

      context "沒有「里程碑」自訂頁面" do
        it "當全站設定有輸入時，顯示全站設定自訂的 Meta Title" do
          site_title = Setting.find_by(name: 'site_title').content
          default_meta_title = Setting.find_by(name: 'meta_title').content
          visit milestones_path
          expect(page).to have_title("#{default_meta_title} | #{site_title}", exact: true)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Keywords" do
          default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
          visit milestones_path
          expect(page).to have_meta(:keywords, default_meta_keywords)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Description" do
          default_meta_desc = Setting.find_by(name: 'meta_desc').content
          visit milestones_path
          expect(page).to have_meta(:description, default_meta_desc)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Title」" do
          default_og_title = Setting.find_by(name: 'og_title').content
          visit milestones_path
          expect(page).to have_og_meta(:title, default_og_title)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Description" do
          default_og_desc = Setting.find_by(name: 'og_desc').content
          visit milestones_path
          expect(page).to have_og_meta(:description, default_og_desc)
        end
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌
#   ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌   ▐░▐░▌
#       ▐░▌          ▐░▌     ▐░▌          ▐░▌▐░▌ ▐░▌▐░▌
#       ▐░▌          ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▐░▌ ▐░▌
#       ▐░▌          ▐░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
#       ▐░▌          ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▀   ▐░▌
#       ▐░▌          ▐░▌     ▐░▌          ▐░▌       ▐░▌
#   ▄▄▄▄█░█▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌
#  ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌
#   ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀
#

  context "列表項目" do
    it "可以看到公開的里程碑" do
      milestone = create(:milestone, :published_tw)
      visit milestones_path
      expect(page).to have_content(milestone.title)
    end

    it "不可以看到隱藏的里程碑" do
      milestone = create(:milestone, :hidden_tw)
      visit milestones_path
      expect(page).not_to have_content(milestone.title)
    end

    it "可以看到「標題」" do
      milestone = create(:milestone, :published_tw)
      visit milestones_path
      expect(page).to have_content(milestone.title)
    end

    it "可以看到「年份」" do
      milestone = create(:milestone, :published_tw)
      visit milestones_path
      expect(page).to have_content(milestone.decorate.year)
    end

    it "可以看到「內容」" do
      milestone = create(:milestone, :published_tw)
      visit milestones_path
      expect(page).to have_content(milestone.content)
    end

    context "圖片" do
      xit "如果有圖片，可以看到圖片" do
        milestone = create(:milestone, :published_tw, :with_image)
        visit milestones_path
        element = find('.milestone-item picture img')
        expect(element[:src]).to include(milestone.image.filename.to_s)
      end

      xit "如果有 alt，可以看到 alt" do
        milestone = create(:milestone, :published_tw, :with_image, :with_image_alt_tw)
        visit milestones_path
        element = find('.milestone-item picture img')
        expect(element[:alt]).to eq(milestone.alt)
      end

      xit "如果沒有 alt，可以看到 title" do
        milestone = create(:milestone, :published_tw, :with_image)
        visit milestones_path
        element = find('.milestone-item picture img')
        expect(element[:alt]).to eq(milestone.title)
      end
    end

    it "里程碑依照 date 排序，越小的越上面" do
      milestone_02 = create(:milestone, :published_tw, date: '2024-02-01')
      milestone_03 = create(:milestone, :published_tw, date: '2024-03-01')
      milestone_01 = create(:milestone, :published_tw, date: '2024-01-01')
      visit milestones_path
      scroll_to(find('.breadcrumb'), align: :top)

      milestones = all('.timeLine-items .item-title')
      expect(milestones.count).to eq(3)

      # 預期的里程碑順序
      expected_milestones = [
        milestone_01.title,
        milestone_02.title,
        milestone_03.title,
      ]

      milestones.each_with_index do |milestone_element, index|
        expect(milestone_element.text).to have_content(expected_milestones[index])
      end
    end
  end
end
