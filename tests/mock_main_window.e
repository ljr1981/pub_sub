note
	description: "[
		Mock Main Window.
		]"
	synopsis: "[
		Use the Pub-Sub library to implement MVC.
		
		View -> 	Controller -> 	Model -> 	...
		[Click]		[Calls]			[Updates]	...
		(A)			(B)				(C)
		
		(A) 
		(B) 
		(C)
		]"

class
	MOCK_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

	PS_BROKER [detachable ANY]
		undefine
			default_create,
			copy
		end

create
	make_with_title

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		do
			create model
			create main_box
			create button.make_with_text ("Press me!")
			create label
			Precursor
		end

	initialize
			-- <Precursor>
		do
			main_box.extend (label.widget)
			main_box.extend (button.widget)
			extend (main_box)
			set_minimum_size (800, 600)
				-- MVC
			model.subscribe_to (button, agent model.set_message)
			label.subscribe_to (model, agent label.set_data)
			Precursor
		end

feature {NONE} -- GUI Objects

	main_box: EV_VERTICAL_BOX

	button: MOCK_BUTTON

	label: MOCK_LABEL

	model: MOCK_MODEL

end
