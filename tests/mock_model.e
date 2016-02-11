note
	description: "[
		Mock Model.
		]"

class
	MOCK_MODEL

inherit
	PS_SUBSCRIBER [detachable ANY]

	PS_PUBLISHER [detachable ANY]

feature {MODEL_CONTROLLER} -- Settings

	set_message (a_message: like data)
		do
			check like_message: attached {like message} a_message as al_message then
				message := al_message
				set_data_and_publish (al_message)
			end
		end

feature {NONE} -- Implementation

	message: detachable STRING_32
			-- `message'.

end
