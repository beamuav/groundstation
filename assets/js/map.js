import L from "leaflet";

const map = L.map("map").setView([-27.272292, 151.282036], 13);

L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

L.marker([-27.272292, 151.282036])
  .addTo(map)
  .bindPopup("Ground Control<br/>to Major Tom");

const polygon = L.polygon(
  [
    [-27.27, 151.28],
    [-27.28, 151.20],
    [-27.24, 151.25]
  ], {
    color: "red",
    fillColor: "#f03",
    weight: 0.75,
    fillOpacity: 0.1
  }
).addTo(map);