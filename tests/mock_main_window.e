note
	description: "[
		Mock Main Window MVC Example.
		]"
	synopsis: "[
		Use the Pub-Sub library to implement MVC.
		
		button: MOCK_BUTTON 	(Publisher to model)
		model: 	MOCK_MODEL 		(Subscriber of button, Publisher to label)
		label: 	MOCK_LABEL 		(Subscriber of model)

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
		rename
			data as unused_data
		redefine
			create_interface_objects,
			initialize
		end

	PS_MODEL_CONTROLLER
		undefine
			default_create,
			copy
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
			create button.make_with_text ("Direct PUB-SUB MVC")
			create broker_button.make_with_text ("Window Brokered PUB-SUB MVC")
			create model_broker.make_with_text ("Model Brokered PUB-SUB MVC")
			create label

			Precursor
		end

	initialize
			-- <Precursor>
		local
			l_hbox: EV_HORIZONTAL_BOX
		do
				-- GUI Initialization/Setup ...
			main_box.extend (label.widget)
			create l_hbox
			l_hbox.extend (button.widget)
			l_hbox.extend (broker_button.widget)
			l_hbox.extend (model_broker.widget)
			main_box.extend (l_hbox)
			main_box.disable_item_expand (l_hbox)
			main_box.set_padding (3)
			main_box.set_border_width (3)
			extend (main_box)
			set_minimum_size (800, 600)

				-- PUB-SUB MVC with direct `button'-to-`model' and `model'-to-`label' ...
			model.subscribe_to (button, agent model.on_direct_publish)
			label.subscribe_to (model, agent label.set_data)

				-- PUB-SUB MVC with `Current' as {PS_BROKER} ...
			add_brokered_with_middleman (broker_button, model, agent model.on_direct_publish, label, agent label.set_data)

				-- PUB-SUB MVC with `model' as {PS_BROKER} ...
			model.add_brokered_subscription (model_broker, label, agent label.on_click_signal)

			Precursor
		end

feature {NONE} -- GUI Objects

	main_box: EV_VERTICAL_BOX
			-- A `main_box' to put `button' and `label' in.

	button,
	broker_button,
	model_broker: MOCK_BUTTON
			-- `button' as first step View-controller triggering {PS_PUBLISHER}.

	model: MOCK_MODEL
			-- `model' as {PS_SUBSCRIBER} to `button' and {PS_PUBLISHER} to `label'.

	label: MOCK_LABEL
			-- `label' as {PS_SUBSCRIBER} to `model', which completes the MVC cycle.

end
