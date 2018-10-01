# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups/Events resource' do
  describe 'GET /groups/:url_slug/events/new' do
    subject(:get_new_event) { get new_group_event_path(group) }

    context 'when the group exists' do
      let!(:group) { FactoryBot.create(:group) }

      context 'and the user signed in is the group owner' do
        before { sign_in(group.owner) }

        it 'renders the new group event form' do
          get_new_event

          expect(response).to have_http_status :ok

          assert_select 'form[action=?][method=?]', group_events_path(group), 'post' do
            assert_select 'input[name=?]', 'event[title]'
            assert_select 'textarea[name=?]', 'event[description]'
            assert_select 'input[name=?][type=?]', 'event[starts_at]', 'datetime-local'
            assert_select 'input[name=?][type=?]', 'event[ends_at]', 'datetime-local'
            assert_select 'input[type=?]', 'submit'
          end
        end
      end

      context 'and the user signed in is not the group owner' do
        before { sign_up }

        it 'returns that the access is forbidden', :realistic_error_responses do
          get_new_event

          expect(response).to have_http_status :forbidden
        end
      end

      context 'and there is no user signed in' do
        it 'returns that the access is unauthorized', :realistic_error_responses do
          get_new_event

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context 'when the group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_new_event

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /groups/:url_slug/events' do
    let(:event_attributes) { FactoryBot.attributes_for(:event) }

    subject(:post_events) { post group_events_path(group), params: { event: event_attributes } }

    context 'when a group exists' do
      let(:group) { FactoryBot.create(:group) }

      context 'when the user signed in is a group administrator' do
        before { sign_in(group.owner) }

        context 'when the parameters passed are valid' do
          it 'creates the event and redirects to the group page' do
            expect { post_events }.to change(Event, :count).by 1

            event = Event.last

            event_attributes[:ends_at] = Time.zone.parse(event_attributes[:ends_at])
            event_attributes[:starts_at] = Time.zone.parse(event_attributes[:starts_at])

            expect(event).to have_attributes(event_attributes)
            expect(event.group).to eq group
            expect(response).to redirect_to(group_path(group))
          end
        end

        context 'when the parameters passed are invalid' do
          let(:event_attributes) { super().merge(title: '') }

          it 'renders the new form with errors and creates no event' do
            expect { post_events }.not_to change(Event, :count)

            expect(response).to have_http_status :unprocessable_entity
            assert_select 'form[action=?][method=?]', group_events_path(group), 'post' do
              assert_select 'p.is-danger', "Title can't be blank"
            end
          end
        end
      end

      context 'when the user signed in is not a group administrator' do
        before { sign_up }

        it 'returns that the access is forbidden and does not create an event', :realistic_error_responses do
          expect { post_events }.not_to change(Event, :count)

          expect(response).to have_http_status :forbidden
        end
      end

      context 'when there is no user signed in' do
        it 'returns that the access is unauthorized and creates no event', :realistic_error_responses do
          expect { post_events }.not_to change(Event, :count)

          expect(response).to have_http_status :unauthorized
        end
      end
    end

    context 'when a group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        post_events

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'GET /groups/:url_slug/events' do
    subject(:get_events) { get group_events_path(group) }

    context 'when a group exists' do
      let!(:group) { FactoryBot.create(:group) }

      it 'displays cards with scheduled talks with most recent first' do
        future_event = FactoryBot.create(:event, starts_at: 5.days.from_now, group: group)
        next_event = FactoryBot.create(:event, starts_at: 2.days.from_now, group: group)

        get_events

        expect(response).to have_http_status :ok

        assert_select '#upcoming-events' do
          assert_select 'h2', 'Upcoming Events'
          assert_select 'div.card' do
            assert_select 'p.title', next_event.title
          end
          assert_select 'div.card' do
            assert_select 'p.title', future_event.title
          end
        end

        expect(next_event.title).to appear_before(future_event.title)
      end

      it 'displays cards with previous talks with most recent first' do
        past_event = FactoryBot.create(:event, starts_at: 5.days.ago, group: group)
        last_event = FactoryBot.create(:event, starts_at: 2.days.ago, group: group)

        get_events

        expect(response).to have_http_status :ok

        assert_select '#previous-events' do
          assert_select 'h2', 'Previous Events'
          assert_select 'div.card' do
            assert_select 'p.title', last_event.title
          end
          assert_select 'div.card' do
            assert_select 'p.title', past_event.title
          end
        end

        expect(last_event.title).to appear_before(past_event.title)
      end
    end

    context 'when a group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }

      it 'returns a not found', :realistic_error_responses do
        get_events

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'GET /groups/:url_slug/events/:event_id' do
    subject(:get_event) { get group_event_path(group, event) }

    context 'when a group does exist' do
      let!(:group) { FactoryBot.create(:group) }

      context 'and the event exists' do
        let!(:event) { FactoryBot.create(:event, group: group) }

        it 'shows details about that event' do
          get_event

          expect(response).to have_http_status :ok

          assert_select '.title', event.title
          assert_select 'p', event.description
        end
      end

      context 'and the event does not exist' do
        let(:event) { Event.new(id: 0) }

        it 'returns a not found', :realistic_error_responses do
          get_event

          expect(response).to have_http_status :not_found
        end
      end

      context 'and the event is present but for a different group' do
        let!(:event) { FactoryBot.create(:event) }

        it 'returns a not found', :realistic_error_responses do
          get_event

          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'when a group does not exist' do
      let(:group) { Group.new(url_slug: 'no-group-here') }
      let(:event) { Event.new(id: 0) }

      it 'returns a not found', :realistic_error_responses do
        get_event

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '/groups/:url_slug/events/:event_id/manage_talks' do
    subject(:get_manage_talks) { get manage_talks_group_event_path(group, event) }

    let!(:group) { FactoryBot.create(:group) }
    let!(:event) { FactoryBot.create(:event, group: group) }

    let!(:suggestion) { FactoryBot.create(:talk_suggestion, group: group) }

    context 'and the user signed in is a group administrator' do
      before { sign_in(group.owner) }

      it 'displays information about prospective and confirmed speakers' do
        get_manage_talks

        expect(response).to have_http_status :ok
        assert_select 'p.title', suggestion.talk.title
        assert_select 'form[action=?][method=?]', schedule_talk_group_event_path(group, event), 'post' do
          assert_select 'input[type=?][name=?][value=?]', 'hidden', 'suggestion_id', suggestion.id.to_s
          assert_select 'input[type=?][value=?]', 'submit', 'Schedule'
        end
      end
    end

    context 'and the user signed in is not the group owner' do
      before { sign_up }

      it 'returns that the access is forbidden', :realistic_error_responses do
        get_manage_talks

        expect(response).to have_http_status :forbidden
      end
    end
  end
end
