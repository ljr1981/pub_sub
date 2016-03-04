note
	description: "[
		Representation of a {PS_PUBLISHER} of {PS_PUBLICATION} items.
		]"
	design: "[
		{PS_PUBLISHER}s have `publications' that the `publish_by_id' to {PS_SUBSCRIBER} {PS_SUBSCRIPTION}s.
		
		Publications are held in a hash with an integer key as a "publication number" for reference
		by subscribers wish to subscribe to particular publications of the Current {PS_PUBLISHER}.
		
		Subscribers call `add_subscription' in order to add their subscription agents to the
		subscriptions on `publications'.
		]"

class
	PS_PUBLISHER [G -> detachable ANY]

inherit
	PS_ANY
	
feature -- Access

	publications: HASH_TABLE [attached like publication_anchor, INTEGER]
			-- `publications' of Current {PS_PUBLISHER}.
		attribute
			create Result.make (10)
		end

feature -- Subscribe

	add_subscription (a_subscription: TUPLE [subscription_agent: PROCEDURE [ANY, TUPLE [G]]; publication_number: INTEGER])
			-- `add_subscription' `a_subscription' with a `subscription_agent' for a `publication_number'.
		require
			has_key: publications.has (a_subscription.publication_number)
		local
			l_subscription: attached like {PS_SUBSCRIBER [G]}.subscription_anchor
		do
			check attached {attached like publication_anchor} publications.item (a_subscription.publication_number) as al_publication then
				create l_subscription
				l_subscription.set_subscription_agent (a_subscription.subscription_agent)
				al_publication.add_subscription (l_subscription)
			end
		end

feature -- Publish

	publish_by_id (a_data: G; a_publication_id: INTEGER)
			-- `publish_by_id' `a_data' to `a_publication_id'.
		require
			has_id: publications.has_key (a_publication_id)
		do
			check has_publication_id: attached {PS_PUBLICATION [G]} publications.item (a_publication_id) as al_publication then
				al_publication.set_data_and_publish (a_data)
			end
		end

	published_by_uuid (a_data: G; a_uuid: UUID)
			-- `publish_by_uuid' `a_data' identified by `a_uuid'.
		require
			has_uuid: across publications as ic_pub some ic_pub.item.uuid ~ a_uuid end
		do
			across publications as ic_pub loop
				if ic_pub.item.uuid = a_uuid then
					ic_pub.item.set_data_and_publish (a_data)
				end
			end
		end

	published_by_uuid_string (a_data: G; a_uuid_string: STRING)
			-- `published_by_uuid_string' `a_data' identified by `a_uuid_string'.
		require
			has_uuid_string: across publications as ic_pub some ic_pub.item.uuid.out.same_string (a_uuid_string) end
		do
			across publications as ic_pub loop
				if ic_pub.item.uuid.out.same_string (a_uuid_string) then
					ic_pub.item.set_data_and_publish (a_data)
				end
			end
		end

feature -- Settings

	add_publications (a_publications: ARRAY [attached like publication_anchor])
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
			across
				a_publications as ic_adding
			loop
				add_publication (ic_adding.item)
			end
		ensure
			added: 	across
						a_publications as ic_adding
					all
						across
							publications as ic_pubs
						some
							ic_pubs.item ~ ic_adding.item
						end
					end
			count_correct: publications.count = old publications.count + a_publications.count
		end

	add_publication (a_publication: attached like publication_anchor)
			-- `add_publication' `a_publication'.
		require
			not_has: across publications as ic all ic.item.uuid /= a_publication.uuid end
		local
			l_count: INTEGER
		do
			l_count := publications.count
			publications.force (a_publication, publications.count + 1)
		ensure
			added: across
				publications as ic_pubs
			some
				ic_pubs.item ~ a_publication
			end
		end

feature {NONE} -- Implementation: Anchors

	publication_anchor: detachable PS_PUBLICATION [G]

end
