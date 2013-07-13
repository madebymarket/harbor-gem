require_relative "account"
require_relative "upload"
require_relative "success_response"

module Harborapp
  class Entity
    attr_accessor :list, :object, :meta

    def initialize(json)
      self.meta = json["meta"] if json["meta"]
      if json["list"]
        self.list = Entity.build_from_list(json["list"])
      else
        self.object = Entity.build_from_hash(json)
      end
    end

    def self.build_from_list(list)
      list.map do |e|
        if e.is_a? Hash
          self.build_from_hash(e)
        elsif e.is_a? Array
          self.build_from_list(e)
        else
          # TODO: throw some weird entity error
        end
      end
    end

    def self.build_from_hash(hash)
      # our hash should always include a class attribute that we can use
      # to map back to a proper Entity type
      #
      if !hash["success"].nil? and hash.keys.length == 1
        return Harborapp::SuccessResponse.new hash["success"]
      end

      hash["new_record"] = false
      case hash["class"]
        when "account"
          Harborapp::Account.new hash
        when "upload"
          Harborapp::Upload.new hash
        else
          raise NoSuchEntity.new("Unknown return type in API response data: #{hash["class"]}")
      end
    end
  end

  class NoSuchEntity < StandardError;
  end
end
