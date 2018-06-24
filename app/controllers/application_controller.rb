# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionManagement
  include AccessDeniedHandler

  helper FormFieldErrorsHelper
end
