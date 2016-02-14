note
	description: "Representation of a Broker between Publishers and Subscribers."
	synopsis: "[
		The purpose of a "Broker" is to facilitate that an added {PS_PUBLISHER} will
		automatically get subscriptions from all known {PS_SUBSCRIBER}s. Likewise,
		adding a {PS_SUBSCRIBER} will place subscriptions on all known {PUBLISHER}s.
		
		The additional purpose of this class is to further remove direct knowledge
		of {PS_PUBLISHER} and {PS_SUBSCRIBER} from each other. Third party brokers can
		be imployed for purposes beyond direct knowledge of their related pubs/subs.
		]"

class
	PS_BROKER [G -> detachable ANY]

inherit
	PS_PUBLISHER [detachable ANY]

	PS_SUBSCRIBER [detachable ANY]

feature -- Basic Operations

	add_brokered_subscription (a_publisher: PS_PUBLISHER [detachable ANY]; a_subscriber: PS_SUBSCRIBER [detachable ANY]; a_subscription_agent: like subscription_agent)
			-- `add_brokered_subscription' to `a_publisher' from `a_subscriber' using `a_subscription_agent'.
		do
			a_subscriber.subscribe_to (a_publisher, a_subscription_agent)
		end

	add_brokered_with_middleman (a_publisher: PS_PUBLISHER [detachable ANY]; a_middle_man: PS_BROKER [detachable ANY]; a_middle_man_subscription_agent: like subscription_agent; a_subscriber: PS_SUBSCRIBER [detachable ANY]; a_subscription_agent: like subscription_agent)
			-- `add_brokered_with_middleman' as `a_middle_man' between `a_publisher' and `a_subscriber'.
		do
			a_middle_man.subscribe_to (a_publisher, a_middle_man_subscription_agent)
			a_subscriber.subscribe_to (a_middle_man, a_subscription_agent)
		end

end
