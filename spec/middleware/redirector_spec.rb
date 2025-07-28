require 'rails_helper'

RSpec.describe Redirector do
  # 參考網址: https://stackoverflow.com/questions/17506567/testing-middleware-with-rspec

  # 建立一個 最簡單的 Rack 應用
  let(:app) { lambda {|env| [200, {'Content-Type' => 'text/plain'}, ['OK']] } }
  # middleware 要接收 app 作為參數
  let(:middleware) { Redirector.new(app) }

  # 使用 Rack::MockRequest 來實際發送請求
  def mock_request(path, host)
    env = Rack::MockRequest.env_for(path, 'HTTP_HOST' => host)
    middleware.call(env)
  end

  # factory_bot
  let(:redirect_with_querystring) { create(:redirect_rule, :query_string) }
  let(:redirect_rule) { create(:redirect_rule) }

  describe '301轉址處理' do
    context '前台 (除了admin開頭以外的host)' do
      let(:frontstage_host) { 'localhost' }

      it '有對應 source_path 時，會轉到 target_path' do
        redirect_rule
        status, headers, _body = mock_request(redirect_rule.source_path, frontstage_host)
        expect(status).to eq(301)
        expect(headers['Location']).to eq(redirect_rule.target_path)
      end

      it '有對應 source_path + query_string 時，會轉到 target_path' do
        redirect_with_querystring
        status, headers, _body = mock_request(redirect_rule.source_path, frontstage_host)
        expect(status).to eq(301)
        expect(headers['Location']).to eq(redirect_rule.target_path)
      end

      # headers['Location'] 只有在重定向的情況下才會設置，所以這裡只有測試status
      it '沒有對應 source_path 時，不會轉址' do
        status, _headers, _body = mock_request('/nonexistpath', frontstage_host)
        expect(status).to eq(200)
      end

      it '沒有對應 source_path + query_string 時，不會轉址' do
        status, _headers, _body = mock_request('/irwebsite/pages.php?id=300', frontstage_host)
        expect(status).to eq(200)
      end
    end

    context '後台 (host以admin開頭)' do
      let(:admin_host) { 'admin-ir.gamania.com' }

      it '有對應 source_path 時，不會會轉到 target_path' do
        redirect_rule
        status, headers, _body = mock_request(redirect_rule.source_path, admin_host)
        expect(status).to eq(200)
      end

      it '有對應 source_path + query_string 時，不會會轉到 target_path' do
        redirect_with_querystring
        status, headers, _body = mock_request(redirect_rule.source_path, admin_host)
        expect(status).to eq(200)
      end

      it '沒有對應 source_path 時，不會轉址' do
        status, _headers, _body = mock_request('/nonexistpath', admin_host)
        expect(status).to eq(200)
      end

      it '沒有對應 source_path + query_string 時，不會轉址' do
        status, _headers, _body = mock_request('/irwebsite/pages.php?id=300', admin_host)
        expect(status).to eq(200)
      end
    end
  end
end
