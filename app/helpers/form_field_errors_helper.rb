# frozen_string_literal: true

module FormFieldErrorsHelper
  def field_errors_for(object, field)
    return unless object.errors.include?(field)

    errors = object.errors.full_messages_for(field)

    errors.map do |error|
      content_tag(:p, error, class: ['help', 'is-danger'])
    end.join.html_safe # rubocop:disable Rails/OutputSafety
  end
end
