export const FastLink = {
  mounted() {
    const linkEl = this.el;

    linkEl.addEventListener("mousedown", (e) => {
      e.preventDefault();
      e.stopImmediatePropagation();
      linkEl.click();
    });
  },
};
