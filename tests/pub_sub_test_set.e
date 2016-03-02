note
	description: "Tests of the PUB-SUB framework."
	testing: "type/manual"

class
	PUB_SUB_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

feature -- Tests: PS_PUBLISHER and PS_SUBSCRIBER

	publisher_subscriber_creation_test
			-- `publisher_test' of {PS_PUBLISHER}.
		note
			testing:
				"execution/isolated",
				"covers/{PS_PUBLISHER}.default_create",
				"covers/{PS_PUBLISHER}.add_publication",
				"covers/{PS_PUBLISHER}.publish_by_id",
				"covers/{PS_PUBLISHER}.published_by_uuid",
				"covers/{PS_PUBLISHER}.published_by_uuid_string",
				"covers/{PS_PUBLICATION}.default_create"
		local
			l_pub: PS_PUBLISHER [ANY]
			l_publication: PS_PUBLICATION [ANY]
			l_sub: PS_SUBSCRIBER [ANY]
			l_subscription: PS_SUBSCRIPTION [ANY]
		do
				-- Set up Publisher and Publications
			create l_pub
			create l_publication
			assert_integers_equal ("has_uuid", 36, l_publication.uuid.out.count)
			l_pub.add_publication (l_publication)
			assert_integers_equal ("has_one", 1, l_pub.publications.count)

				-- Set up Subscriber and Subscriptions
			create l_sub
			create l_subscription
			assert_integers_equal ("has_uuid", 36, l_subscription.uuid.out.count)
			l_sub.subscribe_to (l_publication, agent on_publication_published)

				-- Publish the publication through the publisher
				-- Test by ID
			l_pub.publish_by_id (published_data_string, 1)
			assert_strings_equal ("subscription_data_received_from_publisher", published_data_string, attached_published_data_at_subscriber_level)

				-- Test by UUID
			published_data_at_subscriber_level := Void
			assert ("empty_subscribed_data", not attached published_data_at_subscriber_level)
			l_pub.published_by_uuid (published_data_string, l_publication.uuid)
			assert_strings_equal ("subscription_data_received_from_publisher", published_data_string, attached_published_data_at_subscriber_level)

				-- Test by UUID as STRING
			published_data_at_subscriber_level := Void
			assert ("empty_subscribed_data", not attached published_data_at_subscriber_level)
			l_pub.published_by_uuid_string (published_data_string, l_publication.uuid.out)
			assert_strings_equal ("subscription_data_received_from_publisher", published_data_string, attached_published_data_at_subscriber_level)
		end

feature {NONE} -- Implementation: PS_PUBLISHER and PS_SUBSCRIBER support

	published_data_string: STRING = "WE PUBLISHED_SOMETHING!"
			-- What our publisher publishes.

	on_publication_published (a_data: ANY)
			-- What happens in the subscriber (Current) when the publisher publishes their data (event).
		do
			check has_data: attached {attached like published_data_at_subscriber_level} a_data as al_data then
				published_data_at_subscriber_level := al_data
			end
		end

	attached_published_data_at_subscriber_level: attached like published_data_at_subscriber_level
			-- An attached version of `published_data_at_subscriber_level'.
		do
			check was_published: attached published_data_at_subscriber_level as al_published then Result := al_published end
		end

	published_data_at_subscriber_level: detachable STRING
			-- What was potentially published by the publisher?

feature -- Tests: PS_PUBLICATION and PS_SUBSCRIPTION

	pub_sub_test
			-- Testing of {PS_PUBLICATION} and {PS_SUBSCRIPTION} interaction.
		note
			testing:
				"execution/isolated",
				"covers/{PS_PUBLICATION}.set_data",
				"covers/{PS_PUBLICATION}.add_subscribers",
				"covers/{PS_SUBSCRIPTION}.subscribe_to",
				"covers/{PS_SUBSCRIPTION}.set_subscription_agent"
		local
			l_publisher,
			l_pub2: PS_PUBLICATION [detachable ANY]
			l_subscriber: PS_SUBSCRIPTION [detachable ANY]
		do
				-- Test the passed `a_agent' argument on {PS_SUBSCRIPTION}.
			create l_publisher
			create l_subscriber
			l_subscriber.subscribe_to (l_publisher, agent handle_info)
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data_and_publish (test_data)
			assert ("has_test_data", attached {like test_data} published_data as al_data implies al_data.same_string (test_data))
				-- Test the `subscription_agent' of {PS_SUBSCRIPTION}.
			create l_publisher
			create l_subscriber
			l_subscriber.set_subscription_agent (agent handle_info)
			l_subscriber.subscribe_to (l_publisher, Void)
			published_data := Void
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data_and_publish (test_data)
			assert ("has_publisher_test_data", attached {like test_data} published_data as al_data implies
												al_data.same_string (test_data))
				-- Test `l_pub2' {PS_PUBLICATION}.
			create l_pub2
			l_subscriber.subscribe_to (l_pub2, Void)
			l_pub2.set_data_and_publish (other_data)
			assert ("has_other_data_from_pub2", attached {like test_data} published_data as al_data implies
													al_data.same_string (other_data))
			l_publisher.set_data_and_publish (still_other_data)
			assert ("has_still_other_data_from_publisher", attached {like test_data} published_data as al_data implies
															al_data.same_string (still_other_data))
				-- Test `l_publisher' {PS_PUBLICATION} getting l_subscriber through ...
			create l_publisher
			create l_subscriber
			published_data := Void
			l_subscriber.set_subscription_agent (agent handle_info)
			l_publisher.add_subscriptions (<<l_subscriber>>)
			l_publisher.set_data_and_publish (test_data)
			assert ("has_publisher_test_data_2", attached {like test_data} published_data as al_data implies
												al_data.same_string (test_data))
		end

	broker_tests
		note
			testing:
				"covers/{PS_BROKER}.add_publisher",
				"covers/{PS_BROKER}.publishers",
				"covers/{PS_BROKER}.subscribers",
				"covers/{PS_BROKER}.add_subscriber",
				"covers/{PS_PUBLICATION}.add_subscriber",
				"covers/{PS_PUBLICATION}.subscriptions",
				"covers/{PS_SUBSCRIPTION}.set_subscription_agent",
				"covers/{PS_SUBSCRIPTION}.subscription_agent"
		do
--			test_broker_1.add_publisher (test_publisher_1)
--			test_broker_1.add_subscriber (test_subscriber_1, agent handle_info)
--			assert ("has_published_data", attached {like test_data} published_data as al_data implies
--												al_data.same_string (test_data))

--			broker.add_publisher (button_publisher)
--			broker.add_subscriber (model_publisher_subscriber, agent model_publisher_subscriber.on_brokered_publish)
--			broker.add_publisher (model_publisher_subscriber)
--			broker.add_subscriber (label_subscriber, agent label_subscriber.set_data)
		end

feature {NONE} -- Implementation: PS_PUBLICATION and PS_SUBSCRIPTION

	broker: PS_BROKER [detachable ANY] do create Result end

	button_publisher: MOCK_BUTTON do create Result.make_with_text ("Test") end

	model_publisher_subscriber: MOCK_MODEL do create Result end

	label_subscriber: MOCK_LABEL do create Result end

	test_dispatcher_1: detachable PS_DISPATCH_PUBLISHER

	test_dispatch_receiver_1: detachable PS_DISPATCH_SUBSCRIBER

	test_publishing_agent_1: detachable PS_PUBLISHING_AGENT
			-- Reference to bring "in-system".

	test_publisher_1: PS_PUBLICATION [detachable ANY]
		do
			create Result
			Result.set_data_and_publish (test_data)
		end

	test_subscriber_1: PS_SUBSCRIPTION [detachable ANY]
		do
			create Result
		end

	test_broker_1: PS_BROKER [detachable ANY]
		do
			create Result
		end

	test_data: STRING = "My Data"
	other_data: STRING = "Other Data"
	still_other_data: STRING = "Still Other Data"

	published_data: like {PS_SUBSCRIPTION [detachable ANY]}.data_type_anchor
			-- Data coming from the {PS_PUBLICATION}.

	handle_info (a_data: like {PS_SUBSCRIPTION [detachable ANY]}.data_type_anchor)
			-- A place for the {PS_PUBLICATION} to send their data.
		do
			published_data := a_data
		ensure
			data_set: published_data ~ a_data
		end

end


