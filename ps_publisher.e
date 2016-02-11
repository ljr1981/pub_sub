note
	description: "Abstract notion of a {PS_PUBLISHER}."
	synopsis: "[
		A {PS_PUBLISHER} (like Current) has one or more {SUBSCRIBER}s who "subscribe"
		by way of adding themselves to the list of `subscriptions' (agents). Once
		on this list, any change to the `data' through `set_data' will trigger a
		call to all `subscriptions' (agents) through a call to `publish'.
		
		See {PS_SUBSCRIBER} for more information about the subscription process as
		accomplished from the viewpoint of the {PS_SUBSCRIBER}.
		
		One may add a {PS_SUBSCRIBER} through the `add_subscriber' call, but the passed
		object must have its `subscription_agent' set (i.e. it cannot be Void).
		
		One may also add a list of {PS_SUBSCRIBER} items through `add_subscribers'.
		]"

class
	PS_PUBLISHER

feature -- Access

	subscriptions: ACTION_SEQUENCE [TUPLE [like data]]
			-- `subscriptions' to Current {PS_PUBLISHER}.
		attribute
			create Result
		end

	data: detachable ANY
			-- `data' to send in `publish' to subscribers held in `subscriptions' list.
		attribute
			create Result
		end

feature -- Settings

	set_data (a_data: like data)
			-- `set_data' with `a_data'.
		do
			data := a_data
			publish
		end

feature -- Basic Operations

	add_subscriber (a_subscriber: attached like subscriber_anchor)
			-- `add_subscriber' `subscription_agent' of `a_subscriber' to `subscriptions'.
		require
			has_agent: attached a_subscriber.subscription_agent
		do
			check attached a_subscriber.subscription_agent as al_agent then
				subscriptions.extend (al_agent)
			end
		end

	add_subscribers (a_subscribers: ARRAY [attached like subscriber_anchor])
			-- `add_subscribers' as `a_subscribers' to `subscriptions'.
		require
			all_have_agents: across a_subscribers as ic_subs all attached ic_subs.item.subscription_agent end
		do
			across a_subscribers as ic_subs loop
				check attached ic_subs.item.subscription_agent as al_agent then
					subscriptions.extend (al_agent)
				end
			end
		end

feature -- Anchors

	subscriber_anchor: detachable PS_SUBSCRIBER
			-- `subscriber_anchor' type.

feature {PS_PUBLISHING_AGENT} -- Implementation

	publish
			-- `publish' `data' to all `subscriptions' by calling thier `subscription_agent' items.
		note
			synopsis: "[
				Direct descendants of Current {PS_PUBLISHER} or a {PS_PUBLISHING_AGENT} will have the
				export rights to initiate a call to `publish', which sends the a reference to
				`data' to each {PS_SUBSCRIBER} with an agent in the `subscriptions' list. Thus, you
				can either let a descendant by a type-of {PUBLISHER} or you can create a
				{PS_PUBLISHING_AGENT}, which has one or more {PS_PUBLISHER} objects, which then have
				the right to tell the {PUBLISHER} to `publish'.
				]"
		do
			subscriptions.call ([data])
		end

end
