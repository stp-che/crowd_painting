import { Controller } from "@hotwired/stimulus"

const MAX_SCALE = 30
const CONTENT_SELECTOR = "#paintingContent"

export default class extends Controller {
  initialize() {
    this.dragging = false
    this.scale = 1
    this.contentOffsetX = 0
    this.contentOffsetY = 0
    this.contentElem = this.element.querySelector(CONTENT_SELECTOR)
    this.origWidth = this.contentElem.width
    this.origHeight = this.contentElem.height

    this._initImage()

    this._renderContet()
  }

  clickPixel({ params }) {
    console.log("click pixel", params.row, params.col)
  }

  dragStart() {
    this.dragging = true
  }

  dragStop() {
    this.dragging = false
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

  zoom(event) {
    event.preventDefault()

    let oldScale = this.scale

    // scroll up
    if (event.deltaY < 0 && this.scale < MAX_SCALE) {
      this.scale++
    }

    // scroll down
    if (event.deltaY > 0 && this.scale > 1) {
      this.scale--
    }

    if (this.scale != oldScale) {
      this._renderContet()
    }
  }

  _initImage() {
    let ctx = this.contentElem.getContext("2d");
    this.imgData = ctx.createImageData(this.origWidth, this.origHeight)
    for (let i = 0; i < this.imgData.data.length; i += 4) {
      let row = Math.floor(i / 4 / this.origWidth)
      let col = (i / 4) % this.origWidth
      let red = Math.round(255 * row / this.origHeight)
      let blue = Math.round(255 * col / this.origWidth)
      let shift = 255 - Math.max(red, blue)
      let rgb = [red + shift, shift, blue + shift]
      for (let k = 0; k < rgb.length; k++) {
        if (rgb[k] < 0) {
          rgb[k] = 0
        }
        this.imgData.data[i + k] = rgb[k]
      }
      this.imgData.data[i + 3] = 255
    }

    this.imgData.data[0] = 0
    this.imgData.data[1] = 0
    this.imgData.data[2] = 0
  }

  _renderContet() {
    this.contentElem.width = this.scale * this.origWidth
    this.contentElem.height = this.scale * this.origHeight

    let ctx = this.contentElem.getContext("2d");

    let bitMap = createImageBitmap(this.imgData, {
      resizeWidth: this.contentElem.width,
      resizeHeight: this.contentElem.height,
      resizeQuality: "pixelated"
    }).then(bitMap => {
      ctx.drawImage(bitMap, 0, 0, bitMap.width, bitMap.height, 0, 0, this.contentElem.width, this.contentElem.height)
    })
  }
}
