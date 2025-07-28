require 'rails_helper'

RSpec.describe "中文版 - 常見問題彙整頁及分類頁", type: :system do
  let(:faq) { create(:faq) }
  let(:faqs_page) { create(:custom_page, slug: 'faqs') }
  let(:faqs_page_with_seo) { create(:custom_page, :with_seo, slug: 'faqs') }

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
      faqs_page
      visit faqs_path
      find('.lang-switch-group').click
      find('.dropdown-list-item', text: 'English').click
      expected_content = find('h1')
      expect(expected_content).to have_content(faqs_page.title_en)
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

  context "常見問題彙整頁" do
    context "麵包屑" do
      xit "可以看到麵包屑第一層為「首頁」，並有連結可到中文首頁" do
        faqs_page
        visit faqs_path
        expected_content = find('.breadcrumb-item', text: '首頁')
        expect(expected_content).to have_link('首頁', href: root_path)
      end

      it "可以看到麵包屑顯示依序為「首頁」>「常見問題自訂頁面標題」" do
        faqs_page = create(:custom_page, slug: 'faqs', title: '常見問題')
        visit faqs_path
        breadcrumb_items = all('.breadcrumb-item')

        # 預期的麵包屑順序
        expected_breadcrumbs = ['首頁', '常見問題']

        breadcrumb_items.each_with_index do |item, index|
          expect(item.text).to eq(expected_breadcrumbs[index])
        end
      end
    end

    it "有「常見問題」自訂頁面時，可以看到自訂頁面「標題」，且為「H1」" do
      faqs_page
      visit faqs_path
      expected_content = find('h1')
      expect(expected_content).to have_content(faqs_page.title)
    end

    it "沒有「常見問題」自訂頁面時，可以看到「常見問題」為標題，且為「H1」" do
      visit faqs_path
      expected_content = find('h1')
      expect(expected_content).to have_text('常見問題')
    end

    it "可以看到 第一則分類的 公開常見問題" do
      category = create(:faq_category, :published_tw)
      published_faq = create(:faq, :published_tw, faq_category: category)
      visit faqs_path
      expect(page).to have_text(published_faq.title)
    end

    it "不可以看到 第一則分類的 隱藏常見問題" do
      category = create(:faq_category, :published_tw)
      hidden_faq = create(:faq, :hidden_tw, faq_category: category)
      visit faqs_path
      expect(page).not_to have_text(hidden_faq.title)
    end

    context "Meta Data" do
      context "有「常見問題」自訂頁面" do
        context "Meta Title" do
          it "當有輸入時，顯示自訂 Meta Title" do
            faqs_page_with_seo
            site_title = Setting.find_by(name: 'site_title').content
            visit faqs_path
            expect(page).to have_title("#{faqs_page_with_seo.meta_title} | #{site_title}", exact: true)
          end

          it "當未輸入時，顯示自訂頁面的「標題」" do
            faqs_page
            site_title = Setting.find_by(name: 'site_title').content
            visit faqs_path
            expect(page).to have_title("#{faqs_page.title} | #{site_title}", exact: true)
          end
        end

        context "Meta Keywords" do
          it "當有輸入時，顯示自訂 Meta Keywords" do
            faqs_page_with_seo
            visit faqs_path
            expect(page).to have_meta(:keywords, faqs_page_with_seo.meta_keywords)
          end

          it "當未輸入時，顯示全站設定的 Meta Keywords" do
            faqs_page
            default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
            visit faqs_path
            expect(page).to have_meta(:keywords, default_meta_keywords)
          end
        end

        context "Meta Description" do
          it "當有輸入時，顯示自訂 Meta Description" do
            faqs_page_with_seo
            visit faqs_path
            expect(page).to have_meta(:description, faqs_page_with_seo.meta_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            faqs_page
            default_meta_desc = Setting.find_by(name: 'meta_desc').content
            visit faqs_path
            expect(page).to have_meta(:description, default_meta_desc)
          end
        end

        context "OG Title" do
          it "當有輸入時，顯示自訂 OG Title" do
            faqs_page_with_seo
            visit faqs_path
            expect(page).to have_og_meta(:title, faqs_page_with_seo.og_title)
          end

          it "當未輸入時，顯示全站設定的 OG Title" do
            faqs_page
            default_meta_desc = Setting.find_by(name: 'og_title').content
            visit faqs_path
            expect(page).to have_og_meta(:title, default_meta_desc)
          end
        end

        context "OG Description" do
          it "當有輸入時，顯示自訂 OG Description" do
            faqs_page_with_seo
            visit faqs_path
            expect(page).to have_og_meta(:description, faqs_page_with_seo.og_desc)
          end

          it "當未輸入時，顯示全站設定的 Meta Description" do
            faqs_page
            default_meta_desc = Setting.find_by(name: 'og_desc').content
            visit faqs_path
            expect(page).to have_og_meta(:description, default_meta_desc)
          end
        end
      end

      context "沒有「常見問題」自訂頁面" do
        it "當全站設定有輸入時，顯示全站設定自訂的 Meta Title" do
          site_title = Setting.find_by(name: 'site_title').content
          default_meta_title = Setting.find_by(name: 'meta_title').content
          visit faqs_path
          expect(page).to have_title("#{default_meta_title} | #{site_title}", exact: true)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Keywords" do
          default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
          visit faqs_path
          expect(page).to have_meta(:keywords, default_meta_keywords)
        end

        it "當有全站設定有輸入時，顯示自訂 Meta Description" do
          default_meta_desc = Setting.find_by(name: 'meta_desc').content
          visit faqs_path
          expect(page).to have_meta(:description, default_meta_desc)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Title」" do
          default_og_title = Setting.find_by(name: 'og_title').content
          visit faqs_path
          expect(page).to have_og_meta(:title, default_og_title)
        end

        it "當有全站設定有輸入時，顯示全站設定的「OG Description" do
          default_og_desc = Setting.find_by(name: 'og_desc').content
          visit faqs_path
          expect(page).to have_og_meta(:description, default_og_desc)
        end
      end
    end
  end

#   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
#  ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░▌          ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌
#  ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀
#  ▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌
#  ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄
#  ▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
#   ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀
#

  context "常見問題分類頁" do
    context "麵包屑" do
      xit "可以看到麵包屑第一層為「首頁」，並有連結可到中文首頁" do
        faqs_page
        visit faqs_path
        expected_content = find('.breadcrumb-item', text: '首頁')
        expect(expected_content).to have_link('首頁', href: root_path)
      end

      it "可以看到麵包屑顯示依序為「首頁」>「常見問題」>「分類名稱」" do
        faqs_page = create(:custom_page, slug: 'faqs', title: '常見問題')
        category = create(:faq_category, :published_tw, name: '公告')
        visit cate_faqs_path(faq_category: category.slug)
        breadcrumb_items = all('.breadcrumb-item')

        # 預期的麵包屑順序
        expected_breadcrumbs = ['首頁', '常見問題', '公告']

        breadcrumb_items.each_with_index do |item, index|
          expect(item.text).to eq(expected_breadcrumbs[index])
        end
      end
    end

    it "可以看到狀態為「公開」的分類頁面，標題為「分類名稱」，且為「H1」" do
      faqs_page
      published_category = create(:faq_category, :published_tw)
      visit cate_faqs_path(faq_category: published_category.slug)
      expect(page).to have_content(published_category.name)
    end

    it "不可以看到狀態為「隱藏」的分類頁面" do
      faqs_page
      hidden_category = create(:faq_category, :hidden_tw)
      visit cate_faqs_path(faq_category: hidden_category.slug)
      expect(page).to have_text('ActiveRecord::RecordNotFound')
    end

    it "可以看到 公開且屬於該分類的常見問題" do
      faqs_page
      published_faq = create(:faq, :published_tw)
      category = published_faq.faq_category
      visit cate_faqs_path(faq_category: category.slug)
      expected_content = find('.container .faqs-main')
      scroll_to(expected_content, align: :top)
      expect(expected_content).to have_text(published_faq.title)
    end

    it "不可以看到 隱藏且屬於該分類的常見問題" do
      faqs_page
      hidden_faq = create(:faq, :hidden_tw)
      category = hidden_faq.faq_category
      visit cate_faqs_path(faq_category: category.slug)
      expected_content = find('.container .faqs-main')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(hidden_faq.title)
    end

    it "不可以看到 公開不屬於該分類的常見問題" do
      faqs_page
      create_list(:faq_category, 5, :published_tw)
      target_category = FaqCategory.first
      not_target_category = FaqCategory.last
      faq = create(:faq, :published_tw, faq_category: not_target_category)

      visit cate_faqs_path(faq_category: target_category.slug)
      expected_content = find('.container .faqs-main')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(faq.title)
    end

    it "不可以看到 隱藏且不屬於該分類的常見問題" do
      faqs_page
      create_list(:faq_category, 5, :published_tw)
      target_category = FaqCategory.first
      not_target_category = FaqCategory.last
      faq = create(:faq, :hidden_tw, faq_category: not_target_category)

      visit cate_faqs_path(faq_category: target_category.slug)
      expected_content = find('.container .faqs-main')
      scroll_to(expected_content, align: :top)
      expect(expected_content).not_to have_text(faq.title)
    end

    context "Meta Data" do
      context "Meta Title" do
        it "當有輸入時，顯示自訂 Meta Title" do
          category = create(:faq_category, :published_tw, :with_seo)
          site_title = Setting.find_by(name: 'site_title').content
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_title("#{category.meta_title} | #{site_title}", exact: true)
        end

        it "當未輸入時，顯示常見問題分類的「標題」" do
          category = create(:faq_category, :published_tw)
          site_title = Setting.find_by(name: 'site_title').content
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_title("#{category.name} | #{site_title}", exact: true)
        end
      end

      context "Meta Keywords" do
        it "當有輸入時，顯示自訂 Meta Keywords" do
          category = create(:faq_category, :published_tw, :with_seo)
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:keywords, category.meta_keywords)
        end

        it "當未輸入時，顯示全站設定的 Meta Keywords" do
          category = create(:faq_category, :published_tw)
          default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:keywords, default_meta_keywords)
        end

        it "當全站設定未輸入時，顯示網站預設 Meta Keywords" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:faq_category, :published_tw)
          keywords = Setting.find_by(name: 'meta_keywords')
          keywords.update(content_zh_tw: '')
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:keywords, '易齊, 國際移民, 職業移民, 退休移民')
        end
      end

      context "Meta Description" do
        it "當有輸入時，顯示自訂 Meta Description" do
          category = create(:faq_category, :published_tw, :with_seo)
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:description, category.meta_desc)
        end

        it "當未輸入時，顯示全站設定的 Meta Description" do
          category = create(:faq_category, :published_tw)
          default_meta_desc = Setting.find_by(name: 'meta_desc').content
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:description, default_meta_desc)
        end

        it "當全站設定未輸入時，顯示預設 Meta Description" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:faq_category, :published_tw)
          desc = Setting.find_by(name: 'meta_desc')
          desc.update(content_zh_tw: '')
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_meta(:description, '易齊國際移民有限公司提供專業合法移民服務，專辦各國投資移民、職業移民、退休移民及台灣移民等業務。陪您實現移民夢想，免費諮詢，為您與家人規劃最佳移民方案，共創美好未來。')
        end
      end

      context "OG Title" do
        it "當有輸入時，顯示自訂 OG Title" do
          category = create(:faq_category, :published_tw, :with_seo)
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_og_meta(:title, category.og_title)
        end

        it "當未輸入時，顯示全站設定的「OG Title」" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:faq_category, :published_tw)

          og_title = Setting.find_by(name: 'og_title')
          og_title.update(content_zh_tw: '')
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_og_meta(:title, '易齊國際移民 EZGO 全方位移民專家')
        end
      end

      context "OG Description" do
        it "當有輸入時，顯示自訂 OG Description" do
          category = create(:faq_category, :published_tw, :with_seo)
          visit cate_faqs_path(faq_category: category.slug)
          expect(page).to have_og_meta(:description, category.og_desc(locale: :'zh-TW'))
        end

        xit "當未輸入時，顯示全站設定的「OG Description」" do
          # 目前設定為必填欄位，若改為選填需測試
          category = create(:faq_category, :published_tw)
          og_desc = Setting.find_by(name: 'og_desc')
          og_desc.update(content_zh_tw: '')
          visit cate_faqs_path(faq_category: category.slug)
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
    it "每一頁不可以看到超過「10」則常見問題" do
      faq_category = create(:faq_category, :published_tw)
      faqs = create_list(:faq, 11, :published_tw, faq_category: faq_category)
      all_faqs = faq_category.faqs.publishing.order(position: :asc)
      faq = all_faqs[10]
      visit faqs_path
      scroll_to(find('.breadcrumb'), align: :top)
      expected_content = find('.faqs-main')
      expect(expected_content).not_to have_content(faq.title)
      expect(expected_content).to have_css('.faqs-item', count: 10)
    end

    it "當超過「10」則常見問題時，需看到分頁切換區塊" do
      faq_category = create(:faq_category, :published_tw)
      faqs = create_list(:faq, 11, :published_tw, faq_category: faq_category)
      visit faqs_path
      expected_content = find('.base-pagination')
      expect(expected_content).to have_content('1')
      expect(expected_content).to have_content('2')
    end

    it "當未超過「10」則常見問題時，不可以看到分頁切換區塊" do
      faqs = create_list(:faq, 10, :published_tw)
      visit faqs_path
      scroll_to(find('.faqs-main'), align: :bottom)
      expect(page).not_to have_css('.base-pagination .pagination')
    end

    it "常見問題依照 position 排序，越小的越上面" do
      faq_category = create(:faq_category, :published_tw)
      faq_02 = create(:faq, position: 2, faq_category: faq_category)
      faq_03 = create(:faq, position: 3, faq_category: faq_category)
      faq_01 = create(:faq, position: 1, faq_category: faq_category)
      visit faqs_path
      scroll_to(find('.breadcrumb'), align: :top)
      faqs = all('.faqs-item .faqs-title')
      expect(faqs.count).to eq(3)

      # 預期的常見問題順序
      expected_faqs = [
        faq_01.title,
        faq_02.title,
        faq_03.title,
      ]

      faqs.each_with_index do |faq_element, index|
        expect(faq_element.text).to eq(expected_faqs[index])
      end
    end

    it "可以看到「標題」" do
      faqs_page
      faq = create(:faq, :published_tw)
      visit faqs_path
      expected_content = find('.container .faqs-main .faqs-title')
      expect(expected_content).to have_content(faq.title)
    end
  end
end
