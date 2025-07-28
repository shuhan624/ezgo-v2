class Redirector
  def initialize(app)
    # 初始化方法，每個 middleware 都接收到下一個 middleware 或應用(app) 的參考，@app 儲存這個參考
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # 如果查詢是在後台網址(host 為 admin 開頭)，就跳過轉址
    if request.host.start_with?('admin')
      return @app.call(env)
    end

    # 解碼 URL，避免路徑有中文時，無法正確比對，並且使用 fullpath 取得完整路徑(包含 query string)
    decoded_path = CGI.unescape(request.fullpath)
    rule = RedirectRule.find_by(source_path: decoded_path)
    if rule
      # 找到時，返回 301 狀態碼和新的路徑
      [301, {'Location' => rule.target_path}, ['Redirected']]
    else
      # 沒有找到時，傳給下一個 middleware 或應用
      @app.call(env)
    end
  end
end
