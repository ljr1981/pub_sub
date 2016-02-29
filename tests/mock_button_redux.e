note
	description: "[
		Mock button using the inheritance model rather than 
		the client model.
		]"
	term: "client model", "[
			A class whose design uses a reference feature
			to have access to the features of another class
			rather than using the `inherit' keyword.
			
			Example: widget: EV_BUTTON
		]"
	term: "inheritance model", "[
			A class whose design uses inheritance of another
			class to have access to the features of the 
			other class rather than using a reference feature.
			
			Example: inherit EV_BUTTON
		]"
	comparison: "[
		From a pure readability viewpoint:
		
		(1) The Inherit_clause is more complex in the REDUX.
		(2) The Creation_clause is the same.
		(3) The initialization feature group is the same.
		(4) The `widget' feature is here for convenience (interchangability).
		(5) The `on_click' and `randomizer' features are the same.
		
		The overall impression is that the REDUX version is
		harder to read because it has more code to read.
		Otherwise, the two classes are functionally the same.
		]"

class
	MOCK_BUTTON_REDUX

inherit
	EV_BUTTON
		rename
			data as ev_data
		redefine
			make_with_text,
			make_with_text_and_action
		end

	PS_PUBLICATION [detachable ANY]
		undefine
			default_create,
			copy
		end

create
	default_create,
	make_with_text,
	make_with_text_and_action

feature {NONE} -- Initialization

	make_with_text (a_text: READABLE_STRING_GENERAL)
			-- <Precursor>
		do
			Precursor (a_text)
			select_actions.extend (agent on_click)
		end

	make_with_text_and_action (a_text: READABLE_STRING_GENERAL; an_action: PROCEDURE)
			-- <Precursor>
		do
			Precursor (a_text, an_action)
			select_actions.extend (agent on_click)
		end

feature {EV_WIDGET} -- GUI

	widget: like Current
		once ("OBJECT")
			Result := Current
		end

feature {NONE} -- Implementation: Event Handlers

	on_click
			-- Process `on_click' of `widget', and publish with `set_data_and_publish'.
		do
			set_data_and_publish (randomizer.random_paragraph.to_string_32)
		end

end
