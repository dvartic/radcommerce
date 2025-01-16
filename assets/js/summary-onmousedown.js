export const SummaryMouseDown = {
  mounted() {
    this.el.addEventListener("mousedown", (event) => {
      event.preventDefault();
      this.el.click();
    });

    this.el.addEventListener("click", (event) => {
      if (!event.pointerType) return;
      event.preventDefault();
    });
  },
};
