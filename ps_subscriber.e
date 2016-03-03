note
	description: "[
		Representation of a {PS_SUBSCRIBER} of {PS_SUBSCRIPTION} items.
		]"

class
	PS_SUBSCRIBER [G -> detachable ANY]

feature -- Access

	subscriptions: HASH_TABLE [attached like subscription_anchor, INTEGER]
			-- `subscriptions' of Current {PS_SUBSCRIBER}.
		attribute
			create Result.make (10)
		end

feature -- Subscribe

	subscribe_to (a_publication: PS_PUBLICATION [G]; a_subscription_agent: PROCEDURE [ANY, TUPLE [G]])
			-- `subscribe_to' `a_publication' with `a_subscription'.
		local
			l_subscription: PS_SUBSCRIPTION [G]
		do
			create l_subscription
			l_subscription.subscribe_to (a_publication, a_subscription_agent)
			add_subscription (l_subscription)
		end

feature -- Settings

	add_subscription_agents (a_subscription_agents: ARRAY [PROCEDURE [ANY, TUPLE [detachable G]]])
			-- `add_subscription_agents' from `a_subscription_agents' to `subscriptions'.
		do
			across
				a_subscription_agents as ic_subs
			loop
				add_subscription_agent (ic_subs.item)
			end
		end

	add_subscription_agent (a_subscription_agent: PROCEDURE [ANY, TUPLE [detachable G]])
			-- `add_subscription_agent' `a_subscription_agent' to `subscriptions'.
		local
			l_subscription: attached like subscription_anchor
		do
			create l_subscription
			l_subscription.set_subscription_agent (a_subscription_agent)
			subscriptions.force (l_subscription, subscriptions.count + 1)
		end

feature {NONE} -- Implementation: Anchors

	subscription_anchor: detachable PS_SUBSCRIPTION [G]

end
