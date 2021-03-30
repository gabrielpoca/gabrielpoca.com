import * as __SNOWPACK_ENV__ from './_snowpack/env.js';
import.meta.env = __SNOWPACK_ENV__;

import WaveSurfer from "./_snowpack/pkg/wavesurferjs.js";

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

  const audioEls = document.getElementsByClassName("audioFile");

  Array.from(audioEls).map((el) => {
    el.addEventListener("click", () => {
      setupWavesurfer();
      wavesurfer.load(el.dataset.src);
    });
  });
  
  function setupWavesurfer() {
    if (wavesurfer) return;
    
    playerEl.style.display = "flex";

    console.log('vamos');
    
    wavesurfer = WaveSurfer.create({
      container: playerEl.querySelector(".waveform"),
      waveColor: "#fca5a5",
      progressColor: "#cb90f9",
      cursorColor: "#cb90f9",
      mediaControls: true,
    });

    // console.log(playerEl, playerEl.querySelector('.waveform'));

    wavesurfer.on("play", () => {
      playerEl.getElementsByClassName("play")[0].classList.add("hidden");
      playerEl.getElementsByClassName("pause")[0].classList.remove("hidden");
    });

    wavesurfer.on("pause", () => {
      playerEl.getElementsByClassName("play")[0].classList.remove("hidden");
      playerEl.getElementsByClassName("pause")[0].classList.add("hidden");
    });

    wavesurfer.on("finish", () => {
      playerEl.getElementsByClassName("play")[0].classList.remove("hidden");
      playerEl.getElementsByClassName("pause")[0].classList.add("hidden");
    });

    wavesurfer.on("ready", () => {
      wavesurfer.play();
    });
  }
}

if (undefined /* [snowpack] import.meta.hot */ ) {
  undefined /* [snowpack] import.meta.hot */ .accept(() => window.location.reload());
}
