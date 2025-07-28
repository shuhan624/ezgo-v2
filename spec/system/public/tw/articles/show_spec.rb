require 'rails_helper'

RSpec.describe "中文版 - 最新消息單一文章內頁", type: :system do

  context "不可以看到狀態為「隱藏」的文章內容" do
    it "當文章為「未公開」狀態時，不可以看到該文章" do
      unpubliched_article = create(:article)
      visit article_path(article_category: unpubliched_article.default_category, id: unpubliched_article.slug)
      expect(page).to have_text('ActiveRecord::RecordNotFound')
    end

    it "當文章為「已過發佈時間」狀態時，不可以看到該文章" do
      expired_article = create(:article, :post_tw, :expired_tw)
      visit article_path(article_category: expired_article.default_category, id: expired_article.slug)
      expect(page).to have_text('ActiveRecord::RecordNotFound')
    end

    it "當文章為「未到發佈時間」狀態時，不可以看到該文章" do
      future_article = create(:article, :post_tw, :future_tw)
      visit article_path(article_category: future_article.default_category, id: future_article.slug)
      expect(page).to have_text('ActiveRecord::RecordNotFound')
    end
  end

  context "內容" do
    it "可以看到「標題」，且為「H1」" do
      article = create(:article, :post_tw, :published_tw)
      visit article_path(article_category: article.default_category, id: article.slug)
      expected_content = find('h1')
      expect(expected_content).to have_content(article.title)
    end

    it "可看到「發布日期」" do
      article = create(:article, :post_tw, published_at: '2024-01-27').decorate
      visit article_path(article_category: article.default_category, id: article.slug)
      expect(page).to have_content('2024-01-27')
    end

    it "可以看到「文章內容」" do
      article = create(:article, :post_tw, :published_tw)
      visit article_path(article_category: article.default_category, id: article.slug)
      expected_content = find('.container .custom-editor')
      expect(expected_content).to have_content(article.content)
    end

    context "圖片" do
      context "封面圖" do
        it "有設定封面圖時，可以看到封面圖" do
          article = create(:article, :post_tw, :published_tw, :with_image)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:src]).to include(article.image.filename.to_s)
        end

        it "封面圖有設定 alt 時，可以看到 alt" do
          article = create(:article, :post_tw, :published_tw, :with_image, :with_image_alt)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:alt]).to eq(article.alt)
        end

        it "封面圖沒有設定 alt 時，可以看到文章「標題」" do
          article = create(:article, :post_tw, :published_tw, :with_image)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:alt]).to eq(article.title)
        end
      end

      context "預設圖片" do
        it "沒有輪播圖、封面圖時，可以看到預設圖片" do
          article = create(:article, :post_tw, :published_tw)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:src]).to include('/images/tmp/default-image.jpg')
        end

        it "預設圖片有設定 alt 時，可以看到 alt" do
          article = create(:article, :post_tw, :published_tw, :with_image_alt)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:alt]).to eq(article.alt)
        end

        it "預設圖片沒有設定 alt 時，可以看到文章「標題」" do
          article = create(:article, :post_tw, :published_tw)
          visit article_path(article_category: article.default_category, id: article.slug)
          element = find('.imgbox img')
          expect(element[:alt]).to eq(article.title)
        end
      end
    end
  end

  context "上下篇文章" do
    let!(:category_a) { create(:article_category, :published_tw) }
    let!(:category_b) { create(:article_category, :published_tw) }

    let(:cate_a_article) { create(:article, :post_tw, default_category: category_a, article_categories: [category_a], published_at: Time.current - 10.days) }
    let(:cate_a_next_article) { create(:article, :post_tw, default_category: category_a, article_categories: [category_a], published_at: Time.current - 15.days) }
    let(:cate_a_prev_article) { create(:article, :post_tw, default_category: category_a, article_categories: [category_a], published_at: Time.current - 5.days) }

    let(:cate_b_next_article) { create(:article, :post_tw, default_category: category_b, article_categories: [category_b], published_at: Time.current - 15.days) }
    let(:cate_b_prev_article) { create(:article, :post_tw, default_category: category_b, article_categories: [category_b], published_at: Time.current - 5.days) }

    let(:diff_default_cate_next_article) { create(:article, :post_tw, default_category: category_b, article_categories: [category_a, category_b], published_at: Time.current - 15.days) }
    let(:diff_default_cate_prev_article) { create(:article, :post_tw, default_category: category_b, article_categories: [category_a, category_b], published_at: Time.current - 5.days) }

    it "可以看到上一篇文章" do
      cate_a_article
      cate_a_prev_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)
      link = find('a.post-prev')
      expect(link).to have_text(cate_a_prev_article.title)
    end

    it "可以看到下一篇文章" do
      cate_a_article
      cate_a_next_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)
      link = find('a.post-next')
      expect(link).to have_text(cate_a_next_article.title)
    end

    it "沒有該分類的上一篇文章時，不會出現上一篇文章" do
      cate_a_article
      cate_b_prev_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)
      expect(page).not_to have_text(cate_b_prev_article.title)
    end

    it "沒有該分類的下一篇文章時，不會出現下一篇文章" do
      cate_a_article
      cate_b_next_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)
      expect(page).not_to have_text(cate_b_next_article.title)
    end

    it "上一篇文章的預設分類不同，進入上一篇文章時，不會造成當前的分類變更" do
      cate_a_article
      diff_default_cate_prev_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)

      find('a.post-prev').click
      expect(page.current_path).to eq(article_path(article_category: cate_a_article.default_category, id: diff_default_cate_prev_article.slug))
    end

    it "下一篇文章的預設分類不同，進入下一篇文章時，不會造成當前的分類變更" do
      cate_a_article
      diff_default_cate_next_article
      visit article_path(article_category: cate_a_article.default_category, id: cate_a_article.slug)

      find('a.post-next').click
      expect(page.current_path).to eq(article_path(article_category: cate_a_article.default_category, id: diff_default_cate_next_article.slug))
    end
  end

  context "Meta Data" do
    context "Meta Title" do
      it "當有輸入時，顯示自訂 Meta Title" do
        site_title = Setting.find_by(name: 'site_title').content
        article = create(:article, :post_tw, :published_tw, :with_seo)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_title("#{article.meta_title} | #{site_title}", exact: true)
      end

      it "當未輸入時，顯示最新消息「標題」" do
        site_title = Setting.find_by(name: 'site_title').content
        article = create(:article, :post_tw, :published_tw)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_title("#{article.title} | #{site_title}", exact: true)
      end
    end

    context "Meta Keywords" do
      it "當有輸入時，顯示自訂 Meta Keywords" do
        site_title = Setting.find_by(name: 'site_title').content
        article = create(:article, :post_tw, :published_tw, :with_seo)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_meta(:keywords, article.meta_keywords)
      end

      it "當未輸入時，顯示網站預設 Meta Keywords" do
        default_meta_keywords = Setting.find_by(name: 'meta_keywords').content
        article = create(:article, :post_tw, :published_tw)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_meta(:keywords, default_meta_keywords)
      end
    end

    context "Meta Description" do
      it "當有輸入時，顯示自訂 Meta Description" do
        site_title = Setting.find_by(name: 'site_title').content
        article = create(:article, :post_tw, :published_tw, :with_seo)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_meta(:description, article.meta_desc)
      end

      it "當未輸入時，顯示預設 Meta Description" do
        default_meta_desc = Setting.find_by(name: 'meta_desc').content
        article = create(:article, :post_tw, :published_tw)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_meta(:description, default_meta_desc)
      end
    end

    context "OG Title" do
      it "當有輸入時，顯示自訂 OG Title" do
        article = create(:article, :post_tw, :published_tw, :with_seo)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_og_meta(:title, article.og_title)
      end

      it "當未輸入時，顯示全站設定的「OG Title」" do
        default_og_title = Setting.find_by(name: 'og_title').content
        article = create(:article, :post_tw, :published_tw)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_og_meta(:title, default_og_title)
      end
    end

    context "OG Description" do
      it "當有輸入時，顯示自訂 OG Description" do
        article = create(:article, :post_tw, :published_tw, :with_seo)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_og_meta(:description, article.og_desc)
      end

      it "當未輸入時，顯示全站設定的「OG Description" do
        default_og_desc = Setting.find_by(name: 'og_desc').content
        article = create(:article, :post_tw, :published_tw)
        visit article_path(article_category: article.default_category, id: article.slug)
        expect(page).to have_og_meta(:description, default_og_desc)
      end
    end

    context "canonical url" do
      before(:context) do
        @category_a = create(:article_category, :published_tw)
        @category_b = create(:article_category, :published_tw)
        @article_in_cate_ab = create(:article, :post_tw, :published_tw, default_category: @category_a, article_categories: [@category_a, @category_b])
      end

      after(:context) do
        @article_in_cate_ab.really_destroy!
        ArticleCategory.destroy_all
      end

      it '預設類別 a 的文章，從別的分類進入 canonical 要為 category_a' do
        visit article_path(article_category: @category_b.slug, id: @article_in_cate_ab.slug)

        link_with_port = find('link[rel="canonical"]', visible: false)[:href]
        # 將 port 移除(把冒號後面的數字替換為空字串)
        canonical_link = link_with_port.sub(/:\d+/, '')

        expect(canonical_link).to eq(article_url(article_category: @category_a.slug, id: @article_in_cate_ab.slug))
      end

      it '預設類別 a 的文章，從 category_a 進入 canonical 要為 category_a' do
        visit article_path(article_category: @category_a.slug, id: @article_in_cate_ab.slug)

        link_with_port = find('link[rel="canonical"]', visible: false)[:href]
        canonical_link = link_with_port.sub(/:\d+/, '')

        expect(canonical_link).to eq(article_url(article_category: @category_a.slug, id: @article_in_cate_ab.slug))
      end

      it '預設類別 a 的文章，從 不分類文章進入， canonical 要為 default_category_A' do
        visit articles_path
        find('.post-items a.post-item').click

        link_with_port = find('link[rel="canonical"]', visible: false)[:href]
        canonical_link = link_with_port.sub(/:\d+/, '')

        expect(canonical_link).to eq(article_url(article_category: @category_a.slug, id: @article_in_cate_ab.slug))
      end
    end
  end
end
