note
	description: "[
		Mock Model.
		]"

class
	MOCK_MODEL

inherit
	PS_SUBSCRIBER [detachable ANY]

	PS_PUBLISHER [detachable ANY]

feature -- Acess

	message: detachable STRING_32
			-- `message'.

	set_message (a_message: like data)
		do
			if attached {like message} a_message as al_message then
				message := al_message
				set_data (al_message)
			end
		end

end
