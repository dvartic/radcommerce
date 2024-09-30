// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
// Custom imports
import Alpine from "alpinejs"

// Alpine init
window.Alpine = Alpine;
Alpine.start();

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,

  // Alpine init
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to)
      }
    },
  },

  params: { _csrf_token: csrfToken },

  hooks: {
    InitCheckout: {
      mounted() {
        async function initialize(stripe_session_client) {
          const checkout = await stripe.initEmbeddedCheckout({
            fetchClientSecret: async () => stripe_session_client,
          });

          // Mount Checkout
          checkout.mount("#checkout");

          // Store event listener for destroy
          window.addEventListener("stripe-destroy", () => {
            checkout.destroy()
          })
        }
        initialize(this.el.dataset.checkoutid);

      },
      destroyed() {
        window.dispatchEvent(new CustomEvent("stripe-destroy", {}))
      }
    }
  }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Server Pushed Events Handling
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})

// Stripe Loader and event handling
const stripe = Stripe("pk_test_51I9EOWJJkmhnt45UaoknSdJoLHjuUq29KSp3LLVBRvC4jyko25f8Y5pBwaquTq3y6YO1cbqKpjgK3XAprDyC0caV00lETdvOaX");
