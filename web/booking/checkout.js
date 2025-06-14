initialize();

// Create a Checkout Session
async function initialize() {
  const urlParams = new URLSearchParams(window.location.search);
  const bookingOptionId = urlParams.get("bookingOptionId");
  const classEventId = urlParams.get("classEventId");
  const token = urlParams.get("token");
  const isDev = urlParams.get("dev") === "true";

  const stripe = Stripe(
    isDev
      ? "pk_test_51O3GqCKwmxSCW9DthK2a7OK4oT642myOk2KiiBIk8uqNturYtGiJ4Nz2IqPF67SpjESquJRjZ7I8Vyfkdzu4Knbx00lyD9wCVl"
      : "pk_live_51O3GqCKwmxSCW9DtYK0YflQyi30q4q0KkzboHwaPJ4N3YXsxZ9mE9tlreE3cr6eTWPf1OjH95BvyRnsa3c8NlNzI00vW4e2xap"
  );

  const fetchClientSecret = async () => {
    const response = await fetch(
      isDev
        ? "https://dev.acroworld.de/hasura/v1/graphql"
        : "https://bro-devs.com/hasura/v1/graphql",
      {
        method: "POST",
        headers: {
          authorization: `Bearer ${token}`,
          "content-type": "application/Json",
        },
        body: JSON.stringify({
          operationName: "CreateCheckoutSession",
          variables: {
            booking_option_id: bookingOptionId,
            class_event_id: classEventId,
          },
          query:
            "mutation CreateCheckoutSession($booking_option_id: String!, $class_event_id: String!) {\n  create_checkout_session(\n    booking_option_id: $booking_option_id\n    class_event_id: $class_event_id\n  ) {\n    client_secret\n  }\n}\n",
        }),
      }
    );
    const {
      data: {
        create_checkout_session: { client_secret: clientSecret },
      },
    } = await response.json();
    console.log("clientSecret", clientSecret);
    return clientSecret;
  };

  const checkout = await stripe.initEmbeddedCheckout({
    fetchClientSecret,
  });

  // Mount Checkout
  checkout.mount("#checkout");
}
