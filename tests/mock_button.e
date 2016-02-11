note
	description: "[
		Mock Button as View-trigger
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
	make_with_text

feature {NONE} -- Initialization

	make_with_text (a_text: like widget.text)
			-- `make_with_text' `a_text'.
		do
			create widget.make_with_text (a_text)
			widget.select_actions.extend (agent on_click)
		end

feature {EV_WIDGET} -- GUI

	widget: EV_BUTTON

feature {NONE} -- Implementation: Event Handlers

	on_click
			-- Process `on_click' of `widget', and publish with `set_data_and_publish'.
		do
			if last_message_sent.same_string (First_message) then
				last_message_sent := Second_message
			else
				last_message_sent := First_message
			end
			set_data_and_publish (last_message_sent)
		end

feature {NONE} -- Implementation

	last_message_sent: STRING_32
			-- `last_message_sent' to Subscribers.
		attribute
			Result := Second_message
		end

feature {NONE} -- Implementation: Constants

	First_message: STRING_32 = "First message!"
	Second_message: STRING_32 = "Second message!"

end
