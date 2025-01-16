export const DetailsDropdownClickOutside = {
  mounted() {
    // Handler for clicks outside the dropdown
    this.clickOutsideHandler = (event) => {
      if (!this.el.contains(event.target)) {
        this.el.removeAttribute("open");
      }
    };

    // Add the event listener when the element is mounted
    document.addEventListener("mousedown", this.clickOutsideHandler);
  },

  destroyed() {
    // Clean up the event listener when the element is removed
    document.removeEventListener("mousedown", this.clickOutsideHandler);
  },
};
