# frozen_string_literal: true

module Cohere
  class Base
    attr_reader :client

    def initialize(client:)
      @client = client
    end
  end
end