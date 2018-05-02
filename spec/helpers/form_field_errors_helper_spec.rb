# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormFieldErrorsHelper, type: :helper do
  describe '#field_errors_for' do
    let(:errors) { double }
    let(:object) { double(errors: errors) }
    let(:field) { :test_field }

    context 'when there are no errors present for a particular field' do
      before do
        allow(errors).to receive(:include?).with(field).and_return(false)
      end

      it 'returns nil' do
        expect(helper.field_errors_for(object, field)).to be nil
      end
    end

    context 'when there are errors present for a particular field' do
      before do
        allow(errors).to receive(:include?).with(field).and_return(true)
        allow(errors).to receive(:full_messages_for).with(field).and_return(
          ['Something went wrong', 'So did something else']
        )
      end

      it 'returns a html representation of the errors' do
        expected_html = [
          '<p class="help is-danger">Something went wrong</p>',
          '<p class="help is-danger">So did something else</p>'
        ].join

        expect(helper.field_errors_for(object, field)).to eq expected_html
      end
    end
  end
end
