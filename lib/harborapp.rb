require_relative "harborapp/version"
require_relative "harborapp/api"
require_relative "harborapp/api_response"
require_relative "harborapp/entity"
require_relative "harborapp/api_error"
require "rest_client"
require "json"

module Harborapp
	@api_key = nil
	@api_url = "https://harbor.madebymarket.com/api/v1"

	def self.api_key=(api_key)
		@api_key = api_key
	end
	def self.api_key
		@api_key
	end
	def self.api_url=(api_url)
		@api_url = api_url
	end
	def self.api_url
		@api_url
	end
end
