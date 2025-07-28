require 'rails_helper'

RSpec.describe "Redirects", type: :request do
  describe "GET /redirects" do
    let (:redirect_rule_list) { create_list(:redirect_rule, 20) }
    test_old_paths = {
      '/posts' => '/news',
      '/qa' => '/faqs',
      '/cases' => '/showcases',
      '/introduction' => '/about',
      '/shareholder-services/contacts' => '/contact',
      '/en/articles' => '/en/news',
      '/en/qa' => '/en/faqs',
      '/en/cases' => '/en/showcases',
      '/en/introduction' => '/en/about',
      '/en/shareholder-services/contacts' => '/en/contact',
    }

    test_old_paths.each do |old_path, new_path|
      it "redirects #{old_path} to #{new_path}" do
        get URI::Parser.new.escape(old_path)
        expect(response).to have_http_status(301)
        expect(response).to redirect_to(new_path)
      end
    end

    context 'Add new redirect_rules' do
      it 'redirects source_path to target_path' do
        redirect_rule_list
        RedirectRule.all.each do |rule|
          get URI::Parser.new.escape(rule.source_path)
          expect(response).to have_http_status(301)
          expect(response).to redirect_to(rule.target_path), "Expected redirect to #{rule.target_path} for source path: #{rule.source_path}, but got #{response.redirect_url}"
        end
      end
    end

    context 'redirect_rules 不影響後台的路徑' do
      test_old_paths.each do |old_path, new_path|
        it "redirects #{old_path} to #{new_path}", :admin do
          get URI::Parser.new.escape(old_path)
          expect(response).to have_http_status(404)
        end
      end

      context 'Add new redirect_rules' do
        it 'redirects source_path to target_path', :admin do
          redirect_rule_list
          RedirectRule.all.each do |rule|
            get URI::Parser.new.escape(rule.source_path)
            expect(response).to have_http_status(404)
          end
        end
      end
    end
  end
end
