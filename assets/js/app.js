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
import {
  mountMap,
  updateMap
} from "./map"
import {
  mountView,
  updateView
} from "./view"

function extractLocation(element) {
  return {
    lat: element.getAttribute("data-lat"),
    lng: element.getAttribute("data-lng"),
    alt: element.getAttribute("data-alt"),
    bearing: element.getAttribute("data-bearing"),
    pitch: element.getAttribute("data-pitch")
  }
}

let Hooks = {}
Hooks.Map = {
  mounted() {
    const location = extractLocation(this.el)
    mountMap(location)
    mountView(location)
  },
  updated() {
    const location = extractLocation(this.el)
    updateMap(location)
    updateView(location)
  }
}

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks
})
liveSocket.connect()