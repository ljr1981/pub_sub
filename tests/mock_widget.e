note
	description: "[
		Abstract mock widget.
		]"

deferred class
	MOCK_WIDGET

inherit
	PS_PUBLISHER [detachable ANY]

	PS_SUBSCRIBER [detachable ANY]

feature -- Access

	widget: EV_WIDGET
			-- `widget'.

end
