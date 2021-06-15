import WaveSurfer from "wavesurfer.js";

const playerEl = document.querySelector(".Player");

if (playerEl) {
  let wavesurfer;

  playerEl
    .getElementsByClassName("toggle")[0]
    .addEventListener("click", function () {
      if (wavesurfer.isPlaying()) {
        wavesurfer.pause();
      } else {
        wavesurfer.play();
      }
    });

  const audioEls = Array.from(document.getElementsByClassName("audioFile"));
  let currentAudioEl = null;

  audioEls.map((el) => {
    el.addEventListener("click", () => {
      currentAudioEl?.classList?.remove("playing-audio");

      currentAudioEl = el;
      currentAudioEl.classList.add("playing-audio");

      setupWavesurfer();

      wavesurfer.load(currentAudioEl.dataset.src);
    });
  });

  function setupWavesurfer() {
    if (wavesurfer) return;

    playerEl.style.display = "flex";

    wavesurfer = WaveSurfer.create({
      container: playerEl.querySelector(".waveform"),
      waveColor: "#fca5a5",
      progressColor: "#cb90f9",
      cursorColor: "#cb90f9",
      mediaControls: true,
    });

    wavesurfer.on("play", () => {
      playerEl.getElementsByClassName("play")[0].classList.add("hidden");
      playerEl.getElementsByClassName("pause")[0].classList.remove("hidden");
    });

    wavesurfer.on("pause", () => {
      playerEl.getElementsByClassName("play")[0].classList.remove("hidden");
      playerEl.getElementsByClassName("pause")[0].classList.add("hidden");
    });

    wavesurfer.on("finish", () => {
      const nextEl = audioEls[audioEls.indexOf(currentAudioEl) + 1];

      if (!!nextEl) {
        nextEl.click();
      } else {
        playerEl.getElementsByClassName("play")[0].classList.remove("hidden");
        playerEl.getElementsByClassName("pause")[0].classList.add("hidden");
      }
    });

    wavesurfer.on("ready", () => {
      wavesurfer.play();
    });
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(() => window.location.reload());
}
