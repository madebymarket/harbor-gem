require_relative "entity"
require "json"

module Harborapp
	class ApiResponse
		attr_accessor :_body, :_status, :_headers, :_entity, :errors

		def initialize(response)
			if response.nil? or response.body.nil? or response.code.nil? or response.headers.nil?
				# this response is broken, raise an error.
				raise NilApiResponse.new(500, {}, {"errors" => [{"code" => 990, "message" => "API Server sent back an empty response."}]})
			end

			self._body = ((response.body.is_a? String) ? JSON.parse(response.body) : response.body)
			self._status = response.code
			self._headers = response.headers

			case _status
			when 200, 201
				self._entity = Harborapp::Entity.new(_body)
			when 400,401,403,404,500
				if _body["errors"]
					self.errors = _body["errors"]
					# quickly look to see if we have authentication errors. We want to raise
					# exceptions on api key errors.
					case errors[0]["code"]
					when "002"
						raise InvalidApiKey.new(_status, _hearders, _body)
					when "007"
						raise ExpiredApiKey.new(_status, _hearders, _body)
					end
				end
			else
				# TODO: test unknown resonse and make sure the client can deal with it. 
				raise UnknownResponse.new(_status, _headers, _body)
			end
		end

		# enumeratable methods and such
		def length
			_entity.list.length if _entity.list
		end
		def first
			if _entity.list
				_entity.list.first
			else
				# TODO: some sort of exception
			end
		end

		def success?
			errors.nil? or errors.empty?
		end

		def total_results 
			return nil unless _entity.meta
			_entity.meta["total_results"]
		end
		def offset
			return nil unless _entity.meta
			_entity.meta["offset"]
		end
		def limit
			return nil unless _entity.meta
			_entity.meta["limit"]
		end

		# if we're trying to access a method directly on the ApiResponse,
		# the user is probably trying to get an attribute directly from
		# the single entity that was returned.  In this case, we'll simply
		# look to see if the 
		def method_missing(meth, *args, &block)
			return nil unless _entity
			if _entity.object
				if _entity.object.respond_to? meth
					_entity.object.send(meth, *args, &block)
				else
					raise NoMethodError.new("Unknown attribute #{meth} on ApiResponse or #{_entity.object.class} entity.")
				end
			elsif _entity.list
				if _entity.list.respond_to? meth
					_entity.list.send(meth, *args, &block)
				else
					raise NoMethodError.new("Unknown attribute #{meth} on ApiResponse or #{_entity.list.class} list.")
				end
			end
		end

	end
	
	class JsonParseError < StandardError; end
end
