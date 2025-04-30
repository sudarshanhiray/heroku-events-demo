require_relative '../config/environment' # Load Rails environment
require 'excon'
require 'net/http'
require 'uri'

subscribe_url = ENV['HEROKUEVENTS_SUBSCRIBE_URL']
rails_url = ENV['RAILS_OPPORTUNITY_CHANGE_URL'] || 'https://events-demo-a1377cb950cd.herokuapp.com/opportunity_change'

client = Excon.new(subscribe_url)

loop do
  begin
    resp = client.get(path: '/OpportunityEvents')
    if resp.status == 200 && resp.body && !resp.body.strip.empty?
      Rails.logger.info "Received event: #{resp.body}"

      uri = URI.parse(rails_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      req = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      req.body = resp.body
      http.request(req)
      Rails.logger.info "Posted event to #{rails_url}"
    end
  rescue => e
    Rails.logger.warn "Waiting... (#{e.message})"
  end
  sleep 5
end