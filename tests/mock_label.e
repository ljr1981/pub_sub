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

	set_data (a_data: detachable ANY)
			-- <Precursor>
		do
			check like_widget_text: attached {like widget.text} a_data as al_data  then
				widget.set_text (al_data)
			end
		end

end
