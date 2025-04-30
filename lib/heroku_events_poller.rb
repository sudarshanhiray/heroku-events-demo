require 'excon'
require 'net/http'
require 'uri'

subscribe_url = 'https://705c37db-fef3-4888-b741-6f1bcad39e1c:05521635-e6ff-4e3c-b615-5c3879c23e94@routing-virginia.events.heroku.com' # Set this in your environment
rails_url = ENV['RAILS_OPPORTUNITY_CHANGE_URL'] || 'http://localhost:3001/opportunity_change'

client = Excon.new(subscribe_url)

loop do
  begin
    # The path should match your subscription name
    resp = client.get(path: '/OpportunityEvents')
    if resp.status == 200 && resp.body && !resp.body.strip.empty?
      puts "Received event: #{resp.body}"

      # POST the event to your Rails app
      uri = URI.parse(rails_url)
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      req.body = resp.body
      http.request(req)
    end
  rescue => e
    puts "Waiting... (#{e.message})"
  end
  sleep 5
end