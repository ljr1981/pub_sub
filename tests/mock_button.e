note
	description: "[
		Mock Button as View-trigger using the Client model.
		]"

class
	MOCK_BUTTON

inherit
	MOCK_WIDGET
		redefine
			widget
		end

	PS_PUBLISHER [detachable ANY]

create
	make_with_text,
	make_with_text_and_action

feature {NONE} -- Initialization

	make_with_text (a_text: like widget.text)
			-- `make_with_text' `a_text'.
		do
			create widget.make_with_text (a_text)
			widget.select_actions.extend (agent on_click)
		end

	make_with_text_and_action (a_text: READABLE_STRING_GENERAL; an_action: PROCEDURE)
			-- <Precursor>
		do
			create widget.make_with_text_and_action (a_text, an_action)
			widget.select_actions.extend (agent on_click)
		end

feature {EV_WIDGET} -- GUI

	widget: EV_BUTTON

feature {NONE} -- Implementation: Event Handlers

	on_click
			-- Process `on_click' of `widget', and publish with `set_data_and_publish'.
		do
			set_data_and_publish (Void)
		end

end
