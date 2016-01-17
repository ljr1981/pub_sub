# pub_sub
Pub-Sub library

Objects may communicate (pass "call messages") with each other using a Publisher-Subscriber model of communication. Usually, the Subscriber wants to be informed when a Publisher trigger some event within itself. When the event happens, the Publisher will call agents on a subscription action queue or subscription list.

In this library, the subscription list for a PUBLISHER is an agent-driven action queue, which is the simplest implementation and allows the SUBSCRIBER (or a "Broker" or "Proxy" object) to place an agent to call one of its routines on the queue (subscription list). When the event triggers, the PUBLISHER is responsible for calling (executing) all of the agents on its subscription list.

In this way, a PUBLISHER may have many SUBSCRIBERs and is decoupled from know the semantics (purpose) of the subscription. All the PUBLISHER is responsible for is recording the subscription agent and calling it at event-time (trigger).

In some cases, the SUBSCRIBER wants data from the PUBLISHER, which is passed along as `data'. However, it may be that the SUBSCRIBER only wants to be aware of the event and requires no data. In this case, all that is required is: A) pass a Void or B) ignore whatever is passed.

The library has been sufficiently tested to ensure that it works, but it has not been vetted for efficiency or Big-O. It has been vetted by the Eiffel Inspector tool, which reports (at this time) "no issues."
