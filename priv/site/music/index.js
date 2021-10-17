const playerEl = document.querySelector("#Player-wave");

let wavesurfer;

document.addEventListener("alpine:init", () => {
  Alpine.store("player", {
    src: null,
    title: null,
    isPlaying: true,
    set(src, title) {
      console.log(src, this.src);
      if (src === this.src) {
        wavesurfer.playPause();
      } else {
        onPlay(src);
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

  wavesurfer.on("ready", () => wavesurfer.play());
}

//if (import.meta.hot) {
//import.meta.hot.accept(() => window.location.reload());
//}
