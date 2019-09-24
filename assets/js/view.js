import {
  loadModules
} from 'esri-loader';

loadModules(["esri/Map", "esri/views/SceneView"])
  .then(([Map, SceneView]) => {
    const map = new Map({
      basemap: "hybrid",
      ground: "world-elevation"
    });

    document.view = new SceneView({
      map: map,
      container: "view",
      camera: {
        position: [0, 0, 0],
        tilt: 80
      }
    });
  });