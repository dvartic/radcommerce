export const CycleAdvantages = {
  mounted() {
    const container = this.el;
    const items = Array.from(container.children);
    let currentIndex = 0;
    let intervalId = null;
    const mediaQuery = window.matchMedia("(max-width: 640px)");

    function cycleElements() {
      // Hide all elements
      items.forEach((item) => {
        item.classList.add("opacity-0", "absolute");
      });

      // Show the current element
      items[currentIndex].classList.remove("opacity-0", "absolute");

      // Move to the next element, loop back to 0 if at the end
      currentIndex = (currentIndex + 1) % items.length;
    }

    // Function to check the media query and start or stop the interval
    function checkMediaQuery(mq) {
      if (mq.matches) {
        if (!intervalId) {
          // Start the cycle if it hasn't been started
          cycleElements(); // Initial call
          intervalId = setInterval(cycleElements, 2000);
        }
      } else {
        // Clear the interval if the viewport is larger than 640px
        if (intervalId) {
          clearInterval(intervalId);
          intervalId = null;
          // Optionally, you might want to show all items or hide them when not cycling
          items.forEach((item) => {
            item.classList.remove("opacity-0", "absolute");
          });
        }
      }
    }

    // Initial check
    checkMediaQuery(mediaQuery);

    // Add listener for changes in the media query
    mediaQuery.addListener(checkMediaQuery);
  },
};
