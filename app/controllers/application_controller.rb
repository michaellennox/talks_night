# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionManagement

  helper FormFieldErrorsHelper
end
