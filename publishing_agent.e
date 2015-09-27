note
	description: "Abstract notion of a {PUBLISHING_AGENT}."
	synopsis: "[
		A {PUBLISHING_AGENT} is an abstraction that knows about a group of
		`publishers' that it cares about in terms of either updating and
		publishing the `data' of the {PUBLISHER} when it changes or that
		"notices" changes from other entities on `data' and calls for the
		{PUBLISHER} to `publish'.
		]"

deferred class
	PUBLISHING_AGENT

feature -- Access

	publishers: ARRAYED_LIST [PUBLISHER]
			-- `publishers' utilized by Current {PUBLISHING_AGENT}.
		attribute
			create Result.make (0)
		end

feature -- Basic Operations

	publish_all
			-- Cause all `publishers' to `publish'.
		do
			across publishers as ic_pubs loop ic_pubs.item.publish end
		end

end
