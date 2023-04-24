# frozen_string_literal: true

require_relative "cohere/version"

module Cohere
  class Error < StandardError; end
  # Your code goes here...

  autoload :Client, "cohere/client"
end
