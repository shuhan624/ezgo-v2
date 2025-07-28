class SitemapRefreshJob < ApplicationJob
  queue_as :default

  def perform(*args)
    config_file_en = Rails.root.join('config', 'sitemap_en.rb')
    config_file_tw = Rails.root.join('config', 'sitemap_tw.rb')
    system("RAILS_ENV=#{Rails.env} bundle exec rake sitemap:refresh:no_ping CONFIG_FILE='#{config_file_en}'")
    system("RAILS_ENV=#{Rails.env} bundle exec rake sitemap:refresh:no_ping CONFIG_FILE='#{config_file_tw}'")
  end
end
