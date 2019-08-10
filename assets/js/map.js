import L from "leaflet";

const map = L.map("mapid").setView([-27.15852, 151.26337], 13);

L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution:
    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

L.marker([-27.15852, 151.26337])
  .addTo(map)
  .bindPopup("Ground Control<br/>to Major Tom");

const polygon = L.polygon(
  [[-27.15852, 151.29], [-27.14, 151.27], [-27.17, 151.25]],
  {
    color: "red",
    fillColor: "#f03",
    weight: 0.75,
    fillOpacity: 0.1
  }
).addTo(map);
