// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}
Hooks.Chart = {
	mounted() {
		var root = am5.Root.new("chartdiv");

		root.setThemes([
			am5themes_Animated.new(root)
		]);

		var chart = root.container.children.push(
			am5xy.XYChart.new(root, {
				panX: true,
				panY: true,
				wheelX: "panX",
				wheelY: "zoomX"
			})
		);

		var xAxis = chart.xAxes.push(
			am5xy.DateAxis.new(root, {
				maxDeviation: 0.1,
				groupData: false,
				baseInterval: {
					timeUnit: "week",
					count: 1
				},
				renderer: am5xy.AxisRendererX.new(root, {
					minGridDistance: 50
				}),
				tooltip: am5.Tooltip.new(root, {})
			})
		);

		var yAxis = chart.yAxes.push(
			am5xy.ValueAxis.new(root, {
				maxDeviation: 0.1,
				renderer: am5xy.AxisRendererY.new(root, {})
			})
		);

		var series = chart.series.push(
			am5xy.ColumnSeries.new(root, {
				xAxis: xAxis,
				yAxis: yAxis,
				valueYField: "value",
				valueXField: "date"
			})
		);

		series.appear(1000, 100);
		chart.appear(1000, 100);

		this.handleEvent("add_default_points", ({ points }) =>
			series.data.setAll(points)
		)

		this.handleEvent("add_live_points", ({ points }) =>
			series.data.push(points)
		)
	}
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { longPollFallbackMs: 2500, params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket