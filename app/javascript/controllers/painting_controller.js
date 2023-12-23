import { Controller } from "@hotwired/stimulus"

const MAX_SCALE = 30
const CURSOR_MIN_SIZE = 5
const CONTENT_SELECTOR = "#paintingContent"
const CURSOR_SELECTOR = "#paintingCursor"

export default class extends Controller {
  initialize() {
    this.dragging = false
    this.scale = 1
    this.contentOffsetX = 0
    this.contentOffsetY = 0
    this.contentElem = this.element.querySelector(CONTENT_SELECTOR)
    this.canvasElem = this.contentElem.querySelector('canvas')
    this.cursorElem = this.element.querySelector(CURSOR_SELECTOR)
    this.cursorPos = { row: 0, col: 0 }
    this.origWidth = this.canvasElem.width
    this.origHeight = this.canvasElem.height

    this._initImage()

    this._renderContet()
  }

  moveCursor(event) {
    if (!this._cursorVisible()) {
      return
    }

    let pos = this._getPixel(event.offsetX, event.offsetY)
    if (pos != this.cursorPos) {
      this.cursorPos = pos
      this._adjustCursorPosition()
    }
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

    this._adjustCursor()

    if (this.scale != oldScale) {
      this._renderContet()
    }
  }

  _initImage() {
    let ctx = this.canvasElem.getContext("2d");
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
    this.canvasElem.width = this.scale * this.origWidth
    this.canvasElem.height = this.scale * this.origHeight

    let ctx = this.canvasElem.getContext("2d");

    let bitMap = createImageBitmap(this.imgData, {
      resizeWidth: this.canvasElem.width,
      resizeHeight: this.canvasElem.height,
      resizeQuality: "pixelated"
    }).then(bitMap => {
      ctx.drawImage(bitMap, 0, 0, bitMap.width, bitMap.height, 0, 0, this.canvasElem.width, this.canvasElem.height)
    })
  }

  _adjustCursor() {
    let size = this.scale - 2
    this.cursorElem.style.width = size + 'px'
    this.cursorElem.style.height = size + 'px'
    let visibility = 'hidden'
    if (this._cursorVisible()) {
      visibility = 'visible'
    }
    this.cursorElem.style.visibility = visibility

    this._adjustCursorPosition()
  }

  _adjustCursorPosition() {
    this.cursorElem.style.top = (this.scale * this.cursorPos.row + 1) + 'px'
    this.cursorElem.style.left = (this.scale * this.cursorPos.col + 1) + 'px'
  }

  _cursorVisible() {
    return this.scale >= CURSOR_MIN_SIZE + 2
  }

  _getPixel(offsetX, offsetY) {
    let row = Math.floor(offsetY / this.scale)
    let col = Math.floor(offsetX / this.scale)

    return { row, col }
  }
}
