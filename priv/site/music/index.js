const playerEl = document.querySelector("#Player-wave");

let wavesurfer;

document.addEventListener("alpine:init", () => {
  Alpine.store("player", {
    src: null,
    title: null,
    isLoading: false,
    isPlaying: true,
    set(src, title) {
      if (src === this.src) {
        wavesurfer.playPause();
      } else {
        onPlay(src);
        this.isLoading = true;
        this.src = src;
        this.title = title;
      }
    },
    toggle() {
      wavesurfer.playPause();
    },
  });
});

function onPlay(src) {
  setupWavesurfer();

  wavesurfer.load(src);
}

function setupWavesurfer() {
  if (wavesurfer) return;

  wavesurfer = WaveSurfer.create({
    container: playerEl,
    waveColor: "#fca5a5",
    progressColor: "#cb90f9",
    cursorColor: "#cb90f9",
    mediaControls: true,
  });

  wavesurfer.on("play", () => {
    Alpine.store("player").isPlaying = true;
  });

  wavesurfer.on("pause", () => {
    Alpine.store("player").isPlaying = false;
  });

  wavesurfer.on("finish", () => {});

  wavesurfer.on("ready", () => {
    Alpine.store("player").isLoading = false;
    wavesurfer.play();
  });
}

//if (import.meta.hot) {
//import.meta.hot.accept(() => window.location.reload());
//}
