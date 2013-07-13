require "rest_client"

module Harborapp
	class Api
		@@api_jack = nil

		def self.jack=(double)
	 		@@api_jack = double
		end
		def self.jack
			@@api_jack
		end

		def self.request method, url, params = {}, api_key = :account_api_key
			begin
				basic_username = 	Harborapp.api_key

				if params[:basic_username]
					basic_username = params[:basic_username]
					params.delete(:basic_username)
				end
				if params[:basic_password]
					basic_password = params[:basic_password]
					params.delete(:basic_password)
				end

				req_params = { :user => basic_username, :password => basic_password,
					:method => method, :url => "#{Harborapp.api_url}#{url}", :payload => params}

				self.execute_request(req_params)

			rescue Errno::ECONNREFUSED => e
				raise ApiError.new(500, {}, {"errors" => [{"code" => 993, "message" => "Unable to connect to API server"}]})
			rescue ExpiredApiKey => e
				raise e
			rescue InvalidApiKey => e
				raise e
      rescue Exception => e
			# what kind of generic exceptions might we be loking for?
				raise ApiError.new(500, {}, {"errors" => [{"code" => 996, "message" => "Error getting response from API server "+e.inspect}]})
			end
		end
		
		def self.execute_request(params)
			if Harborapp::Api.jack
				ApiResponse.new Harborapp::Api.jack.execute(params)
			else
				RestClient::Request.new(params).execute do |response, request, result, &block|
					ApiResponse.new(response)
				end
			end
		end

		def self.xml_request method, url, params = {}
				basic_username = 	Harborapp.api_key
				req_params = { :method => method, :url => url, :payload => params}

				self.execute_xml_request(req_params)
			
		end

		def self.execute_xml_request(params)
			if Harborapp::Api.jack
				ApiResponse.new Harborapp::Api.jack.execute(params)
			else
				RestClient::Request.new(params).execute do |response, request, result, &block|
					response
				end
			end
		end
	end
end
