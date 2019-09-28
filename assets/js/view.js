import {
  loadModules
} from 'esri-loader';

export function mountView(location) {
  loadModules(["esri/Map", "esri/views/SceneView"])
    .then(([Map, SceneView]) => {
      const map = new Map({
        basemap: "hybrid",
        ground: "world-elevation"
      });

      document.view = new SceneView({
        map: map,
        container: "view"
      });

      updateView(location);
    });
}

export function updateView(location) {
  if (document.view) {
    document.view.goTo({
      position: {
        latitude: parseFloat(location.lat),
        longitude: parseFloat(location.lng),
        z: parseFloat(location.alt),
      },
      zoom: 13,
      heading: parseFloat(location.bearing),
      tilt: 90 + parseFloat(location.pitch)
    });
  }
}