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
			set_data_and_publish (randomizer.random_paragraph.to_string_32)
		end

feature {NONE} -- Implementation

	randomizer: RANDOMIZER
			-- `randomizer' of Current.
		once
			create Result
		end

end
