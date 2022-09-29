document.addEventListener("alpine:init", () => {
  const wavesurfer = WaveSurfer.create({
    container: '#waveform',
    waveColor: "rgb(107 114 128)",
    progressColor: "#bf6aff",
    cursorColor: "#cb90f9",
    mediaControls: false,
    normalize: true,
    height: 64,
    responsive: true,
    backend: 'MediaElement'
  });

  wavesurfer.on("play", () => {
  });

  wavesurfer.on('ready', () => {
    wavesurfer.play();
  })

  wavesurfer.on("play", () => {
    Alpine.store("player").isPlaying = true;
  });

  wavesurfer.on("pause", () => {
    Alpine.store("player").isPlaying = false;
  });

  Alpine.store("player", {
    src: null,
    title: null,
    isPlaying: false,
    opened: {},
    playPause() {
      wavesurfer.playPause();
    },
    selected(url) {
      return this.src === url;
    },
    playing(url) {
      if (url)
        return this.isPlaying && this.src === url;
      else
        return this.isPlaying;
    },
    open(src) {
      this.opened[src] = true;
    },
    async set(src, title) {
      this.open(src);

      if (src === this.src) {
        wavesurfer.playPause();
      } else {
        wavesurfer.pause();
        document.getElementById("waveform").classList.remove("hidden");

        this.src = src;
        this.title = title;

        try {
          const response = await fetch(this.src.replace('.mp3', '.json'));

          if (!response.ok)
            throw new Error('HTTP error ' + response.status);

          const json = await response.json();

          wavesurfer.load(this.src, json.data);
        } catch (e) {
          wavesurfer.load(this.src);
        }
      }
    }
  });

  Alpine.directive('log', (el, { expression }, { evaluate }) => {
    console.log(
      evaluate(expression)
    )
  })
});
