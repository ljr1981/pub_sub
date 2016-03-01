note
	description: "[
		Representation of a {PS_SUBSCRIBER} of {PS_SUBSCRIPTION} items.
		]"

class
	PS_SUBSCRIBER [G -> ANY]

feature -- Access

	subscriptions: HASH_TABLE [attached like subscription_anchor, INTEGER]
			-- `subscriptions' of Current {PS_SUBSCRIBER}.
		attribute
			create Result.make (10)
		end

feature -- Subscribe

	subscribe_to_publication (a_subscriber_agent: PROCEDURE [ANY, TUPLE [G]]; a_publication: PS_PUBLICATION [G])
			-- `subscribe_to_publication' with `a_subscriber_agent' to `a_publication'.
		local
			l_subscription: PS_SUBSCRIPTION [G]
		do
			create l_subscription
			l_subscription.set_subscription_agent (a_subscriber_agent)
			a_publication.add_subscription (l_subscription)
		end

feature -- Settings

	add_subscriptions (a_subscriptions: ARRAY [attached like subscription_anchor])
			-- `add_subscriptions' from `a_subscriptions' to `subscriptions'.
		do
			across
				a_subscriptions as ic_subs
			loop
				add_subscription (ic_subs.item)
			end
		end

	add_subscription (a_subscription: attached like subscription_anchor)
			-- `add_subscription' `a_subscription' to `subscriptions'.
		do
			subscriptions.force (a_subscription, subscriptions.count + 1)
		end

feature {NONE} -- Implementation: Anchors

	subscription_anchor: detachable PS_SUBSCRIPTION [G]

end
