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
		rename
			set_data_and_publish as set_data_from_broker
		redefine
			set_data_from_broker
		end

feature {EQA_TEST_SET, PS_MODEL_CONTROLLER} -- Settings

	set_message (a_message: like data)
			-- `set_message' with `a_message' and then `set_data_and_publish'.
			-- Make this call when not using a {PS_BROKER}.
		do
			check like_message: attached {like message} a_message as al_message then
				message := al_message
				set_data_from_broker (al_message)
			end
		end

	set_data_from_broker (a_data: like data)
			-- <Precursor>
			-- Make this call when using a {PS_BROKER}.
			-- When using a {PS_BROKER} we do not need to publish as the broker handles it.
		do
			check like_message: attached {like message} a_data as al_message then
				message := al_message
					-- Code copied from ancestor instead of making Precursor (a_data) call.
				data := a_data
				-- publish <-- This call (from the ancestor) is removed as it creates circular endless looping calls.
			end
		end

feature {NONE} -- Implementation

	message: detachable STRING_32
			-- `message' for Current to receive (as Subscriber) from the GUI and publish back to the GUI.

end
