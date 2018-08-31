# frozen_string_literal: true

module Requests
  module AppearBeforeMatcher
    extend RSpec::Matchers::DSL

    matcher :appear_before do |later_content|
      match do |earlier_content|
        response.body.index(earlier_content) < response.body.index(later_content)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Requests::AppearBeforeMatcher, type: :request
end
