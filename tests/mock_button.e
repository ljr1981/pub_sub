note
	description: "[
		Mock Button (Publisher)
		]"

class
	MOCK_BUTTON

inherit
	MOCK_WIDGET
		redefine
			widget
		end

create
	make_with_text

feature {NONE} -- Initialization

	make_with_text (a_text: like widget.text)
			-- `make'
		do
			create widget.make_with_text (a_text)
			widget.select_actions.extend (agent set_data (widget.text + " -> Clicked!"))
		end

feature -- Access

	widget: EV_BUTTON

end
