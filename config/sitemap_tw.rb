# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https:/www.ezgoimmi.com/"
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.filename = :sitemap_tw

SitemapGenerator::Sitemap.create do

  add articles_path
  ArticleCategory.publishing.each do |category|
    add cate_articles_path(article_category: category)
  end

  Article.post.published.each do |article|
    add article_path(article_category: article.default_category, id: article.slug), lastmod: article.updated_at
  end

  add faqs_path
  FaqCategory.publishing.each do |category|
    add cate_faqs_path(faq_category: category)
  end

  %w(about privacy terms thanks).each do |page|
    add send("#{page}_path")
  end

  CustomPage.non_default_pages.publishing.each do |page|
    add custom_page_path(id: page.slug), lastmod: page.updated_at
  end
end
