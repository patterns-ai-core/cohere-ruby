# frozen_string_literal: true

require "spec_helper"

RSpec.describe Cohere::Client do
  let(:instance) { described_class.new(api_key: "123") }
end
