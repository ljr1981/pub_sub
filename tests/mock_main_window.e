note
	description: "[
		Mock Main Window MVC Example.
		]"
	synopsis: "[
		Use the Pub-Sub library to implement MVC.
		
		button: MOCK_BUTTON
		model: MOCK_MODEL
		label: MOCK_LABEL

		View -> 	Controller -> 	Model -> 	...
		[Click]		[Calls]			[Updates]	...
		(A)			(B)				(C)
		
		(A) `button'	: Clicking triggers controller (Publisher), calling `set_message' on model (as Subscriber).
		(B) `model'		: Model executes `set_message' (as Subscriber), which in turn calls `set_data_and_publish' 
							on model (as Publisher), calling `set_data_and_publish' on `label' (as View-Subscriber).
		(C) `label'		: Label executes `set_data_and_publish', which sets the pubished value from the `button'.
		]"
		EIS: "name=MVC", "src=$GITHUB/pub_sub/docs/Model–view–controller.pdf"

class
	MOCK_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects,
			initialize
		end

	MODEL_CONTROLLER
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
				-- GUI Initialization/Setup ...
			main_box.extend (label.widget)
			main_box.extend (button.widget)
			extend (main_box)
			set_minimum_size (800, 600)

				-- MVC Setup ...
			model.subscribe_to (button, agent model.set_message)
			label.subscribe_to (model, agent label.set_data)

			Precursor
		end

feature {NONE} -- GUI Objects

	main_box: EV_VERTICAL_BOX
			-- A `main_box' to put `button' and `label' in.

	button: MOCK_BUTTON
			-- `button' as first step View-controller triggering {PS_PUBLISHER}.

	model: MOCK_MODEL
			-- `model' as {PS_SUBSCRIBER} to `button' and {PS_PUBLISHER} to `label'.

	label: MOCK_LABEL
			-- `label' as {PS_SUBSCRIBER} to `model', which completes the MVC cycle.

end
