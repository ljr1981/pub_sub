note
	description: "[
		Abstract notion of an entity which is both {PS_PUBLISHER} and {PS_SUBSCRIBER}.
		]"

deferred class
	PS_PUBLISHER_SUBSCRIBER [G -> detachable ANY]

inherit
	PS_SUBSCRIBER [G]
		rename
			add_subscription_agent as subscriber_add_subscription
		end

	PS_PUBLISHER [G]
		rename
			add_subscription as publisher_add_subscription
		end

end
