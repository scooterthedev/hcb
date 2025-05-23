# frozen_string_literal: true

module EventMappingEngine
  module Map
    class StripeTopUps
      def run
        stripe_top_ups.find_each(batch_size: 100) do |ct|
          guessed_event_id = ::EventMappingEngine::GuessEventId::StripeTopUp.new(canonical_transaction: ct).run

          next unless guessed_event_id

          attrs = {
            canonical_transaction_id: ct.id,
            event_id: guessed_event_id
          }
          ::CanonicalEventMapping.create!(attrs)
        end
      end

      private

      def stripe_top_ups
        ::CanonicalTransaction.unmapped.stripe_top_up.order("date asc")
      end

    end
  end
end
