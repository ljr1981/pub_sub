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
	PS_SUBSCRIBER [detachable ANY]  -- Note (A) (above)

	PS_PUBLISHER [detachable ANY]	-- Note (B) (above)

feature {PS_MODEL_CONTROLLER} -- Settings

	set_message (a_message: like data)
			-- `set_message' with `a_message' and then `set_data_and_publish'.
		do
			check like_message: attached {like message} a_message as al_message then
				message := al_message
				set_data_and_publish (al_message)
			end
		end

feature {NONE} -- Implementation

	message: detachable STRING_32
			-- `message' for Current to receive (as Subscriber) from the GUI and publish back to the GUI.

end
