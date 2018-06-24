# frozen_string_literal: true

AccessDeniedError = Class.new(StandardError)

module AccessDeniedHandler
  extend ActiveSupport::Concern

  included do
    rescue_from AccessDeniedError do
      if current_user
        render file: Rails.root.join('public', '403.html'), status: 403, layout: false
      else
        render file: Rails.root.join('public', '401.html'), status: 401, layout: false
      end
    end
  end
end
