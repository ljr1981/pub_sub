note
	description: "[
		Mock Model.
		]"
	synopsis: "[
		(A) We only inherit from {PS_SUBSCRIBER} if our model object wants to get 
		information from the GUI.
		
		(B) We only inherit from {PS_PUBLISHER} if our GUI wants to get information
		from our model.
		]"

class
	MOCK_MODEL

inherit
	PS_BROKER [detachable ANY]

feature {EQA_TEST_SET, PS_MODEL_CONTROLLER} -- Settings

	on_direct_publish (a_data: like data)
			-- What happens `on_direct_publish'.
		do
			generate_new_message
			set_data_and_publish (message)
		end

	on_brokered_publish (a_data: like data)
			-- What happens `on_brokered_publish'.
		do
			generate_new_message
			data := message
		end

feature {NONE} -- Implementation

	generate_new_message
			-- `generate_new_message' into `message'
		do
			message := randomizer.random_paragraph.twin + Explanation
		end

	message: detachable STRING_32
			-- `message' for Current to receive (as Subscriber) from the GUI and publish back to the GUI.

	Explanation: STRING = "%N%NThis data is being generated in {MOCK_MODEL} and sent on to whoever the subscriber is, which does not have to be just or only {MOCK_LABEL}."

feature {NONE} -- Implementation

	randomizer: RANDOMIZER
			-- `randomizer' of Current.
		once ("OBJECT")
			create Result
		end

end
