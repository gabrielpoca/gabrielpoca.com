document.addEventListener("alpine:init", () => {
  Alpine.store("player", {
    src: null,
    title: null,
    isPlaying: false,
    selected(url) {
      return this.src === url;
    },
    playing(url) {
      return this.isPlaying && this.src === url;
    },
    async set(el, src, title) {
      if (src === this.src) {
        if (el.paused) await el.play();
        else {
          el.pause();
        }
      } else {
        this.src = src;
        this.title = title;

        el.currentTime = 0;
        await el.play();
      }

      this.isPlaying = !el.paused;
    },
  });


  Alpine.directive('log', (el, { expression }, { evaluate }) => {
    console.log(
      evaluate(expression)
    )
  })
});
