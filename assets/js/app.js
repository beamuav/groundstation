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
import {
  plane
} from "./map"

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
    document.map = L.map("map").setView(location, 13)
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(document.map)

    document.mapMarker = L.marker(location, {
      icon: plane(location.bearing)
    }).addTo(document.map)

    if (document.view) {
      document.view.goTo({
        center: [parseFloat(location.lat), parseFloat(location.lng), parseFloat(location.alt)],
        zoom: 13,
        heading: parseFloat(location.bearing),
        tilt: 80
      })
    }
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

    if (document.view) {
      // console.log({
      //   location
      // })
      document.view.goTo({
        heading: parseFloat(location.bearing),
        tilt: 80,
        position: {
          latitude: parseFloat(location.lat),
          longitude: parseFloat(location.lng),
          z: parseFloat(location.alt),
        }
      })
    }
  }
}


let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks
})
liveSocket.connect()