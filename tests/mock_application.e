note
	description: "[
		Mock EV Application.
		]"

class
	MOCK_APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			create application
			create main_window.make_with_title ("Mock")

			application.post_launch_actions.extend (agent main_window.show)
			main_window.close_request_actions.extend (agent application.destroy)

			application.launch
		end

feature {NONE} -- Implementation

	application: EV_APPLICATION

	main_window: MOCK_MAIN_WINDOW

end
