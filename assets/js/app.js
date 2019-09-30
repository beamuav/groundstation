// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
//import socket from "./socket"

import LiveSocket from "phoenix_live_view"
import {
  Socket
} from "phoenix";
import L from "leaflet"
import {
  loadModules
} from 'esri-loader';

let Hooks = {}
Hooks.Map = {
  mounted() {
    const location = {
      lat: this.el.getAttribute("data-lat"),
      lng: this.el.getAttribute("data-lng"),
      alt: this.el.getAttribute("data-alt"),
      bearing: this.el.getAttribute("data-bearing"),
      pitch: this.el.getAttribute("data-pitch")
    }
    document.map = L.map("map", {
      zoomControl: false
    }).setView(location, 13)
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(document.map)

    document.mapMarker = L.marker(location, {
      icon: plane(location.bearing)
    }).addTo(document.map)

    mountView(location)
  },
  updated() {
    const location = {
      lat: this.el.getAttribute("data-lat"),
      lng: this.el.getAttribute("data-lng"),
      alt: this.el.getAttribute("data-alt"),
      bearing: this.el.getAttribute("data-bearing"),
      pitch: this.el.getAttribute("data-pitch")
    }
    document.map.setView(location, 12)
    document.mapMarker.setLatLng(location).setIcon(plane(location.bearing))

    updateView(location)
  }
}


let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks
})
liveSocket.connect()


function mountView(location) {
  loadModules(["esri/Map", "esri/views/SceneView"])
    .then(([Map, SceneView]) => {
      const view = document.view = new SceneView({
        map: new Map({
          basemap: "satellite",
          ground: "world-elevation",
          ui: {
            components: []
          }
        }),
        ui: {
          components: []
        },
        environment: {
          starsEnabled: false,
          atmosphereEnabled: true
        },
        qualityProfile: "low",
        container: "view",
        zoom: 12,
        tilt: 90,
        rotation: 0,
        center: {
          latitude: parseFloat(location.lat),
          longitude: parseFloat(location.lng),
          z: parseFloat(location.alt),
        }
      });

      view.on("focus", function (event) {
        event.stopPropagation();
      });
      view.on("key-down", function (event) {
        event.stopPropagation();
      });
      view.on("mouse-wheel", function (event) {
        event.stopPropagation();
      });
      view.on("double-click", function (event) {
        event.stopPropagation();
      });
      view.on("double-click", ["Control"], function (event) {
        event.stopPropagation();
      });
      view.on("drag", function (event) {
        event.stopPropagation();
      });
      view.on("drag", ["Shift"], function (event) {
        event.stopPropagation();
      });
      view.on("drag", ["Shift", "Control"], function (event) {
        event.stopPropagation();
      });
    });
}

function updateView(location) {
  if (document.view) {
    const value = {
      position: {
        latitude: parseFloat(location.lat),
        longitude: parseFloat(location.lng),
        z: parseFloat(location.alt),
      },
      zoom: 12,
      heading: parseFloat(location.bearing),
      tilt: 90
    }
    document.view.goTo(value, {
      animate: false
    });
  }
}

function plane(bearing) {
  return L.icon({
    iconUrl: `data:image/svg+xml;utf8,<svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" transform="rotate(${45 + parseInt(bearing)} 0 0)">
   <path fill="black" 
      d="M 4.7932777,4.7812376 C 4.7259064,4.8486085 4.7323964,4.9347702 4.9650313,5.4373336 C 4.9924894,5.4966515 5.1453716,5.7138571 5.1453716,5.7138571 C 5.1453723,5.7138561 5.0426847,5.8268489 5.0148394,5.8546943 C 4.9610053,5.9085284 4.9361984,6.0293335 4.958161,6.1243469 C 5.026297,6.4191302 5.8480608,7.5947712 6.3081405,8.0548517 C 6.593652,8.3403629 6.7408456,8.5354068 6.730653,8.6147666 C 6.7220521,8.6817367 6.6138788,8.9698607 6.4901987,9.2536889 C 6.2719706,9.7544933 6.1902268,9.8530093 3.7284084,12.592571 C 1.7788774,14.76205 1.1823532,15.462131 1.1469587,15.620578 C 1.0488216,16.059908 1.4289737,16.468046 2.4110617,16.977428 L 2.9177343,17.24021 C 2.9177343,17.24021 10.306553,11.950215 10.306553,11.950215 L 14.736066,15.314858 L 14.634732,15.495198 C 14.578751,15.594046 14.11587,16.171307 13.60593,16.778194 C 13.095992,17.385083 12.673006,17.939029 12.666441,18.009665 C 12.640049,18.293626 13.777085,19.186772 13.947719,19.016137 C 14.217037,18.74682 15.346696,17.884968 15.441971,17.875697 C 15.509995,17.869079 16.481025,17.128624 16.810843,16.798805 C 17.140662,16.468987 17.881117,15.497956 17.887735,15.429933 C 17.897006,15.334658 18.758859,14.204999 19.028176,13.93568 C 19.198811,13.765045 18.305664,12.62801 18.021702,12.654403 C 17.951067,12.660967 17.397123,13.083953 16.790233,13.593891 C 16.183346,14.103831 15.606085,14.566712 15.507236,14.622693 L 15.326897,14.724027 L 11.962253,10.294514 C 11.962253,10.294514 17.252249,2.9056938 17.25225,2.9056938 L 16.989466,2.3990218 C 16.480084,1.416933 16.071947,1.0367811 15.632617,1.1349189 C 15.474169,1.1703136 14.774089,1.7668355 12.60461,3.7163677 C 9.8650471,6.1781859 9.7665321,6.2599294 9.2657298,6.4781579 C 8.9819013,6.601838 8.6937782,6.7100098 8.6268071,6.7186131 C 8.5474478,6.7288044 8.352405,6.5816098 8.0668925,6.2960996 C 7.6068129,5.8360191 6.4311712,5.0142561 6.1363875,4.9461203 C 6.0413739,4.9241577 5.92057,4.9489642 5.8667352,5.0027982 C 5.8388891,5.0306446 5.7276147,5.1316136 5.7276147,5.1316136 C 5.7276147,5.1316136 5.5104099,4.9787304 5.4510923,4.9512732 C 4.9485278,4.7186391 4.8606505,4.7138647 4.7932777,4.7812376 z" /></svg>`,
    iconSize: [32, 32]
  });
}