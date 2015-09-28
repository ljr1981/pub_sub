note
	testing: "type/manual"

class
	PUB_SUB_TEST_SET

inherit
	TEST_SET_HELPER

feature -- Test routines

	pub_sub_test
			-- Testing of {PUBLISHER} and {SUBSCRIBER} interaction.
		note
			testing:  "execution/isolated"
		local
			l_publisher,
			l_pub2: PUBLISHER
			l_subscriber: SUBSCRIBER
		do
				-- Test the passed `a_agent' argument on {SUBSCRIBER}.
			create l_publisher
			create l_subscriber
			l_subscriber.subscribe_to (l_publisher, agent handle_info)
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data (test_data)
			assert ("has_test_data", attached {like test_data} published_data as al_data implies al_data.same_string (test_data))
				-- Test the `subscription_agent' of {SUBSCRIBER}.
			create l_publisher
			create l_subscriber
			l_subscriber.set_subscription_agent (agent handle_info)
			l_subscriber.subscribe_to (l_publisher, Void)
			published_data := Void
			assert ("not_has_data", not attached published_data)
			l_publisher.set_data (test_data)
			assert ("has_publisher_test_data", attached {like test_data} published_data as al_data implies
												al_data.same_string (test_data))
				-- Test `l_pub2' {PUBLISHER}.
			create l_pub2
			l_subscriber.subscribe_to (l_pub2, Void)
			l_pub2.set_data (other_data)
			assert ("has_other_data_from_pub2", attached {like test_data} published_data as al_data implies
													al_data.same_string (other_data))
			l_publisher.set_data (still_other_data)
			assert ("has_still_other_data_from_publisher", attached {like test_data} published_data as al_data implies
															al_data.same_string (still_other_data))
				-- Test `l_publisher' {PUBLISHER} getting l_subscriber through ...
			create l_publisher
			create l_subscriber
			published_data := Void
			l_subscriber.set_subscription_agent (agent handle_info)
			l_publisher.add_subscribers (<<l_subscriber>>)
			l_publisher.set_data (test_data)
			assert ("has_publisher_test_data_2", attached {like test_data} published_data as al_data implies
												al_data.same_string (test_data))
		end

feature {NONE} -- Implementation

	test_data: STRING = "My Data"
	other_data: STRING = "Other Data"
	still_other_data: STRING = "Still Other Data"

	published_data: like {SUBSCRIBER}.data_type_anchor
			-- Data coming from the {PUBLISHER}.

	handle_info (a_data: like {SUBSCRIBER}.data_type_anchor)
			-- A place for the {PUBLISHER} to send their data.
		do
			published_data := a_data
		ensure
			data_set: published_data ~ a_data
		end

end


