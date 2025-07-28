# frozen_string_literal: true

class Admin::PassthroughController < AdminController
  def index
    if current_admin.cw_chief?
      path = admin_dashboard_path
    else
      path = find_admin_path
    end
    path ||= '/404'

    redirect_to path
  end

  private

  def find_admin_path
    paths = {
      dashboard: admin_dashboard_path,
      article: admin_articles_path,
      contact: admin_contacts_path,
      custom_page: admin_custom_pages_path,
      faq: admin_faqs_path,
      article_category: admin_article_categories_path,
      faq_category: admin_faq_categories_path,
      home_slide: admin_home_slides_path,
      partner: admin_partners_path,
      document: admin_documents_path,
      milestone: admin_milestones_path,
      redirect_rule: admin_redirect_rules_path,
      user: admin_users_path,
      admin: admin_admins_path
    }

    # 找到符合條件 hash 的 path
    paths.find { |key, _path| current_admin.can?(:index, key) }&.last
  end
end
