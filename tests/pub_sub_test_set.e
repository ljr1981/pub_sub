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

feature -- Test routines

	pub_sub_test
			-- Testing of {PS_PUBLISHER} and {PS_SUBSCRIBER} interaction.
		note
			testing:
				"execution/isolated",
				"covers/{PS_PUBLISHER}.set_data",
				"covers/{PS_PUBLISHER}.add_subscribers",
				"covers/{PS_SUBSCRIBER}.subscribe_to",
				"covers/{PS_SUBSCRIBER}.set_subscription_agent"
		local
			l_publisher,
			l_pub2: PS_PUBLISHER [detachable ANY]
			l_subscriber: PS_SUBSCRIBER [detachable ANY]
		do
				-- Test the passed `a_agent' argument on {PS_SUBSCRIBER}.
			create l_publisher
			create l_subscriber
			l_subscriber.subscribe_to (l_publisher, agent handle_info)
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data_and_publish (test_data)
			assert ("has_test_data", attached {like test_data} published_data as al_data implies al_data.same_string (test_data))
				-- Test the `subscription_agent' of {PS_SUBSCRIBER}.
			create l_publisher
			create l_subscriber
			l_subscriber.set_subscription_agent (agent handle_info)
			l_subscriber.subscribe_to (l_publisher, Void)
			published_data := Void
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data_and_publish (test_data)
			assert ("has_publisher_test_data", attached {like test_data} published_data as al_data implies
												al_data.same_string (test_data))
				-- Test `l_pub2' {PS_PUBLISHER}.
			create l_pub2
			l_subscriber.subscribe_to (l_pub2, Void)
			l_pub2.set_data_and_publish (other_data)
			assert ("has_other_data_from_pub2", attached {like test_data} published_data as al_data implies
													al_data.same_string (other_data))
			l_publisher.set_data_and_publish (still_other_data)
			assert ("has_still_other_data_from_publisher", attached {like test_data} published_data as al_data implies
															al_data.same_string (still_other_data))
				-- Test `l_publisher' {PS_PUBLISHER} getting l_subscriber through ...
			create l_publisher
			create l_subscriber
			published_data := Void
			l_subscriber.set_subscription_agent (agent handle_info)
			l_publisher.add_subscribers (<<l_subscriber>>)
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
				"covers/{PS_PUBLISHER}.add_subscriber",
				"covers/{PS_PUBLISHER}.subscriptions",
				"covers/{PS_SUBSCRIBER}.set_subscription_agent",
				"covers/{PS_SUBSCRIBER}.subscription_agent"
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

feature {NONE} -- Implementation

	broker: PS_BROKER [detachable ANY] do create Result end

	button_publisher: MOCK_BUTTON do create Result.make_with_text ("Test") end

	model_publisher_subscriber: MOCK_MODEL do create Result end

	label_subscriber: MOCK_LABEL do create Result end

	test_dispatcher_1: detachable PS_DISPATCH_PUBLISHER

	test_dispatch_receiver_1: detachable PS_DISPATCH_SUBSCRIBER

	test_publishing_agent_1: detachable PS_PUBLISHING_AGENT
			-- Reference to bring "in-system".

	test_publisher_1: PS_PUBLISHER [detachable ANY]
		do
			create Result
			Result.set_data_and_publish (test_data)
		end

	test_subscriber_1: PS_SUBSCRIBER [detachable ANY]
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

	published_data: like {PS_SUBSCRIBER [detachable ANY]}.data_type_anchor
			-- Data coming from the {PS_PUBLISHER}.

	handle_info (a_data: like {PS_SUBSCRIBER [detachable ANY]}.data_type_anchor)
			-- A place for the {PS_PUBLISHER} to send their data.
		do
			published_data := a_data
		ensure
			data_set: published_data ~ a_data
		end

end


