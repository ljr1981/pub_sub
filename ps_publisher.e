note
	description: "[
		Representation of a {PS_PUBLISHER} of {PS_PUBLICATION} items.
		]"
	design: "[
		{PS_PUBLISHER}s have `publications' that the `publish' to {PS_SUBSCRIBER} {PS_SUBSCRIPTION}s.
		]"

class
	PS_PUBLISHER [G -> ANY]

feature -- Access

	publications: ARRAYED_LIST [PS_PUBLICATION [G]]
			-- `publications' of Current {PS_PUBLISHER}.
		attribute
			create Result.make (10)
		end

feature -- Settings

	add_publication (a_publication: PS_PUBLICATION [G])
			-- `add_publication' `a_publication'.
		require
			not_has: across publications as ic all ic.item.uuid /= a_publication.uuid end
		do
			publications.force (a_publication)
		ensure
			added: publications.has (a_publication)
		end

	add_publications (a_publications: like publications)
			-- `add_publications' like `a_publications'.
		require
			not_has_all: across publications as ic_pubs all
								across
									a_publications as ic_adding
								all
									ic_pubs.item.uuid /= ic_adding.item.uuid
								end
							end
		do
			publications.append (a_publications)
		ensure
			added: 	across
						a_publications as ic_adding
					all
						publications.has (ic_adding.item)
					end
		end

end
