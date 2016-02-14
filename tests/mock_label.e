note
	description: "[
		Mock Label as update-enabled {PS_SUBSCRIBER}.
		]"

class
	MOCK_LABEL

inherit
	MOCK_WIDGET
		redefine
			default_create,
			widget
		end

	PS_SUBSCRIBER [detachable ANY]
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			create widget
			set_subscription_agent (agent widget.set_text)
		end

feature {EV_WIDGET} -- GUI

	widget: EV_TEXT

feature {EQA_TEST_SET, EV_WIDGET} -- Event Handlers

	on_click_signal (a_data: detachable ANY)
			-- `on_click_signal' is Void.
		do
			check no_data: not attached a_data end
			widget.set_text (Explanation)
		end

	Explanation: STRING = "[
Model broker button was clicked!

This data is being generated at the label level. We can send along and pass along data from
any source, we have chosen to respond to `a_data' in `on_click_signal' as just that--a signal.
No data is passed other than Void. We check for that in the routine (see `on_click_signal').
]"

	set_data (a_data: detachable ANY)
			-- <Precursor>
		do
			check like_widget_text: attached {like widget.text} a_data as al_data  then
				widget.set_text (al_data)
			end
		end

end
