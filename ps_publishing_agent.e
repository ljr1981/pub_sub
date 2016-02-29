note
	description: "Abstract notion of a {PS_PUBLISHING_AGENT}."
	synopsis: "[
		A {PS_PUBLISHING_AGENT} is an abstraction that knows about a group of
		`publishers' that it cares about in terms of either updating and
		publishing the `data' of the {PS_PUBLICATION} when it changes or that
		"notices" changes from other entities on `data' and calls for the
		{PS_PUBLICATION} to `publish'.
		]"

deferred class
	PS_PUBLISHING_AGENT

feature -- Access

	publishers: ARRAYED_LIST [PS_PUBLICATION [detachable ANY]]
			-- `publishers' utilized by Current {PS_PUBLISHING_AGENT}.
		attribute
			create Result.make (10)
		end

feature -- Basic Operations

	publish_all
			-- Cause all `publishers' to `publish'.
		do
			across publishers as ic_pubs loop ic_pubs.item.publish end
		end

end
