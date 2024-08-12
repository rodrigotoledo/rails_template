import ApplicationController from "controllers/application_controller"

export default class extends ApplicationController {
  connect () {
    super.connect()
  }

  // beforeSearch(element, reflex, noop, id) {
  //  console.log("before search", element, reflex, id)
  // }

  // searchQueued(element, reflex, noop, id) {
  //   console.log("search enqueued for delivery upon connection", element, reflex, id)
  // }

  // searchDelivered(element, reflex, noop, id) {
  //   console.log("search delivered to the server", element, reflex, id)
  // }

  // searchSuccess(element, reflex, noop, id) {
  //   console.log("search successfully executed", element, reflex, id)
  // }

  // searchError(element, reflex, error, id) {
  //   console.error("search server-side error", element, reflex, error, id)
  // }

  // searchHalted(element, reflex, noop, id) {
  //   console.warn("search halted before execution", element, reflex, id)
  // }

  // searchForbidden(element, reflex, noop, id) {
  //   console.warn("search forbidden from executing", element, reflex, id)
  // }

  // afterSearch(element, reflex, noop, id) {
  //   console.log("search has been executed by the server", element, reflex, id)
  // }

  // finalizeSearch(element, reflex, noop, id) {
  //   console.log("search changes have been applied", element, reflex, id)
  // }
}
