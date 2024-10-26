export const FormSubmitOnMousedown = {
  mounted() {
    this.el.addEventListener("mousedown", (e) => {
      e.preventDefault();
      this.el.closest("form").requestSubmit();
    });
    this.el.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopImmediatePropagation();
    });
  },
};
