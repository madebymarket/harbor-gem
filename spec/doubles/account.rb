require_relative "../mock_response"

def login_success
	MockResponse.new(200, {"Content-Type" => "application/json"}, {
		class: "account",
		email: "user@harbor.madebymarket.com",
		api_key: "d000c50a4a996ef80a632345caed7dba"
	}.to_json)
end

def success_response
	MockResponse.new(200, {"Content-Type" => "application/json"}, {
		"success" => true,
	})
end
