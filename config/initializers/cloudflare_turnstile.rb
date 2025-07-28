turnstile = Rails.application.credentials.dig(:cloudflare, :turnstile)
if Rails.env.local?
  turnstile ||= {
                  site_key: 'DUMMY_SITE_KEY',
                  secret_key: 'DUMMY_SECRET_KEY'
                }
end

RailsCloudflareTurnstile.configure do |c|
  c.site_key = turnstile[:site_key]
  c.secret_key = turnstile[:secret_key]
  c.fail_open = true
  c.enabled = false if Rails.env.local?
end
