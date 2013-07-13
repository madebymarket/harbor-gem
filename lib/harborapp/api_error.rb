module Harborapp
	class ApiError < StandardError
		attr_accessor :status, :headers, :errors
		def initialize(status, headers, body)
			self.status = status
			self.headers = headers
			self.errors = body["errors"]
		end
	end

	class ExpiredApiKey < ApiError; end
	class InvalidApiKey < ApiError; end
	class UnknownResponse < ApiError; end
	class NilApiResponse < ApiError; end
end
