note
	description: "[
		Mock Label.
		]"

class
	MOCK_LABEL

inherit
	MOCK_WIDGET
		redefine
			default_create,
			widget,
			set_data
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		do
			set_subscription_agent (agent widget.set_text)
		end

feature -- Access

	widget: EV_LABEL
		attribute
			create Result
		end

feature -- Basic Operations

	set_data (a_data: like data)
		do
			check attached {like widget.text} a_data as al_data  then
				widget.set_text (al_data)
			end
		end

end
