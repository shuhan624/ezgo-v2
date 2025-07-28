redirect_rules = {
  '/posts' => '/news',
  '/qa' => '/faqs',
  '/introduction' => '/about',
  '/shareholder-services/contacts' => '/contact',
  '/en/articles' => '/en/news',
  '/en/introduction' => '/en/about',
  '/en/shareholder-services/contacts' => '/en/contact',
  '/website/event.php?year=2022' => '/news'
}

redirect_rules.each do |source_path, target_path|
  rule = RedirectRule.find_by(source_path: source_path)
  if rule.present?
    rule.update!(target_path: target_path)
  else
    RedirectRule.create!(source_path: source_path, target_path: target_path)
  end
end
