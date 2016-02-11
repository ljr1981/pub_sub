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
	PS_BROKER

feature -- Access

	publishers: ARRAYED_LIST [attached like publisher_anchor]
			-- `publishers' of Current {PS_BROKER}.
		attribute
			create Result.make (10)
		end

	subscribers: ARRAYED_LIST [attached like subscriber_anchor]
			-- `subscribers' of Current {PS_BROKER}.
		attribute
			create Result.make (10)
		end

feature -- Basic Operations

	add_publisher (a_publisher: attached like publisher_anchor)
			-- `add_brokered_publisher' as `a_publisher' to `publishers' and add subscriptions from all `subscribers'.
		do
			publishers.force (a_publisher)
			across subscribers as ic_subscriber loop
				a_publisher.add_subscriber (ic_subscriber.item)
			end
		end

	add_subscriber (a_subscriber: attached like subscriber_anchor; a_agent: attached like {attached like subscriber_anchor}.subscription_agent)
			-- `add_brokered_subscriber' as `a_subscriber' to `subscribers' and subscribe to `publishers'.
		require
			not_subscribers: not subscribers.has (a_subscriber)
		do
			a_subscriber.set_subscription_agent (a_agent)
			subscribers.force (a_subscriber)
			across publishers as ic_publisher loop
				ic_publisher.item.add_subscriber (a_subscriber)
			end
		end

feature -- Anchors

	publisher_anchor: detachable PS_PUBLISHER
			-- `publisher_anchor' type.

	subscriber_anchor: detachable PS_SUBSCRIBER
			-- `subscriber_anchor' type.

end
