note
	description: "Abstract notion of a {PS_SUBSCRIBER}."
	synopsis: "[
		A {PS_SUBSCRIBER} wants to know about changes to {PS_PUBLISHER}.data
		by way of adding its `subscription_agent' to the `subscriptions' of it
		through the mechanism of a call to `subscribe_to', passing said {PUBLISHER}
		and an optional agent.
		
		With regards to the relationship between `subscription_agent' and the `a_agent'
		argument of `subscribe_to', one must know that a subscription agent is required
		either by pre-setting it on `subscription_agent' or by passing in the optional
		`a_agent' argument (e.g. not Void). Moreover, a non-Void `a_agent' passed to
		`subscribe_to' will override any existing `subscription_agent' already set on
		the {PS_SUBSCRIBER} (e.g. it will be ignored in favor of the argument agent).
		
		One may also subscribe the Current {PS_SUBSCRIBER} to `a_publishers' list in
		`subscribe_all'.
		]"

class
	PS_SUBSCRIBER [G -> detachable ANY]

feature -- Access

	subscription_agent: detachable PROCEDURE [ANY, TUPLE [like data_type_anchor]]
			-- Optional `subscription_agent' used in `subscribe_to' of Current {PS_SUBSCRIBER}.

feature -- Settings

	set_subscription_agent (a_agent: attached like subscription_agent)
			-- Set `subscription_agent' with `a_agent'.
		do
			subscription_agent := a_agent
		ensure
			agent_set: subscription_agent ~ a_agent
		end

feature -- Basic Operations

	subscribe_to (a_publisher: attached like publisher_type_anchor; a_agent: like subscription_agent)
			-- `subscribe_to' `a_publisher', with optional `a_agent' or default `subscription_agent'
		require
			has_agent: attached a_agent or else attached subscription_agent
		do
			if attached a_agent then
				a_publisher.subscriptions.extend (a_agent)
			elseif attached subscription_agent as al_agent then
				a_publisher.subscriptions.extend (al_agent)
			end
		end

	subscribe_all (a_publishers: ARRAY [attached like publisher_type_anchor]; a_agent: like subscription_agent)
			-- Subscribe to `a_publishers' list with either an optional `a_agent' or `subscription_agent'.
		do
			across a_publishers as ic_pubs loop
				subscribe_to (ic_pubs.item, a_agent)
			end
		end

feature {NONE} -- Type anchors

	publisher_type_anchor: detachable PS_PUBLISHER [G]
			-- Valid `publisher_type_anchor' that {PS_PUBLISHER}s for Current {PS_SUBSCRIBER}.

	data_type_anchor: detachable G
			-- Valid `data_type_anchor' that Current {PS_SUBSCRIBER} can consume from {PS_PUBLISHER}.

invariant
	publisher_type_anchor_void: not attached publisher_type_anchor
	data_type_anchor_void: not attached data_type_anchor

end
