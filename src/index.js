import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import * as potrace from "potrace-js/src/index";

const app = Main.embed(document.getElementById("root"));

const options = {
  turnpolicy: "minority",
  turdsize: 2,
  optcurve: true,
  alphamax: 1,
  opttolerance: 0.2
};

app.ports.sendSvgUrl.subscribe(url =>
  potrace
    .traceUrl("./buddy.jpg", options)
    .then(paths => potrace.getSVG(paths, 1.0, "curve"))
    .then(app.ports.receiveSvg.send)
);

registerServiceWorker();