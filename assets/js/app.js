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
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
// Custom imports
import Alpine from "alpinejs";
import { SwiperProductPage } from "./swiper-product-page.js";
import { ChangeLanguageSelector } from "./change-language-selector.js";
import { HeaderLinkActive } from "./header-link-active.js";
import { CycleAdvantages } from "./hero-adv-cycle.js";
import { FastLink } from "./fast-link.js";
import { FormSubmitOnMousedown } from "./form-submit-onmousedown.js";

// Alpine init
window.Alpine = Alpine;
Alpine.start();

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,

  // Alpine init
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
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
            checkout.destroy();
          });
        }
        initialize(this.el.dataset.checkoutid);
      },
      destroyed() {
        window.dispatchEvent(new CustomEvent("stripe-destroy", {}));
      },
    },
    SwiperProductPage,
    ChangeLanguageSelector,
    HeaderLinkActive,
    CycleAdvantages,
    FastLink,
    FormSubmitOnMousedown,
  },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Custom events support. Use qphx-{{event}} to execute a custom event not provided natively by LiveView.
window.addEventListener("mousedown", (e) => {
  // Check if it's a left click (button property is 0 for left click)
  if (e.button !== 0) return;

  // if the event's target has the qphx-mousedown attribute,
  // execute the commands on that element
  const element = e.target.closest("[qphx-mousedown]");
  if (element) {
    const action = element.getAttribute("qphx-mousedown");
    liveSocket.execJS(element, action);
  }

  document.querySelectorAll("[qphx-mousedown-away]").forEach((el) => {
    if (!el.contains(e.target)) {
      liveSocket.execJS(el, el.getAttribute("qphx-mousedown-away"));
    }
  });
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// Server Pushed Events Handling. Allows to execute JS code from the server,  previously stored in a data attribute.
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach((el) => {
    liveSocket.execJS(el, el.getAttribute(detail.attr));
  });
});

// Stripe Loader
let stripePublicKey = document
  .querySelector("meta[name='stripe-public']")
  .getAttribute("content");
const stripe = Stripe(stripePublicKey);
