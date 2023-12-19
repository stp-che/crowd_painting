import { Controller } from "@hotwired/stimulus"

const contentSelector = "#paintingContent"

export default class extends Controller {
  initialize() {
    this.dragging = false
    this.contentOffsetX = 0
    this.contentOffsetY = 0
    this.contentElem = this.element.querySelector(contentSelector)
  }

  clickPixel({ params }) {
    console.log("click pixel", params.row, params.col)
  }

  dragStart() {
    this.dragging = true
  }

  dragStop() {
    this.dragging = false
    console.log("drag stop")
  }

  drag(event) {
    if (!this.dragging) {
      return true
    }

    this.contentOffsetX = this.contentOffsetX + event.movementX
    this.contentOffsetY = this.contentOffsetY + event.movementY
    this.contentElem.style.left = this.contentOffsetX + 'px'
    this.contentElem.style.top = this.contentOffsetY + 'px'
  }
}
