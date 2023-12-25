import { Controller } from "@hotwired/stimulus"
import api from '../api'

const MAX_SCALE = 30,
      CURSOR_MIN_SIZE = 5

export default class extends Controller {
  static targets = [ "content", "canvas", "cursor", "colorPicker", "image" ]
  static values = { canvasUrl: String, pixelChangesUrl: String }

  initialize() {
    this.dragging = false
    this.wasJustDragged = false
    this.scale = 1
    this.contentOffsetX = 0
    this.contentOffsetY = 0
    this.cursorPos = { row: 0, col: 0 }
    this.origWidth = this.canvasTarget.width
    this.origHeight = this.canvasTarget.height
    this.canvasCtx = this.canvasTarget.getContext("2d");
  }

  connect() {
    // assign src after the onload handler is set
    this.imageTarget.src = this.canvasUrlValue
  }

  imageLoaded() {
    this.canvasCtx.drawImage(this.imageTarget, 0, 0);
    this.imgData = this.canvasCtx.getImageData(0, 0, this.origWidth, this.origHeight)
  }

  moveCursor(event) {
    let pos = this._getPixelByCoords(event.offsetX, event.offsetY)
    if (pos != this.cursorPos) {
      this.cursorPos = pos
      if (this._cursorVisible()) {
        this._adjustCursorPosition()
      }
    }
  }

  clickPixel(event) {
    if (this.wasJustDragged) {
      this.wasJustDragged = false
      return
    }

    this._postPixelChange(this.cursorPos, this.colorPickerTarget.value)
      .then(_ => this._changePixel(this.cursorPos, this.colorPickerTarget.value))
  }

  dragStart(event) {
    this.dragging = true
  }

  dragStop(event) {
    this.dragging = false
  }

  drag(event) {
    if (!this.dragging) {
      return true
    }

    this.contentOffsetX = this.contentOffsetX + event.movementX
    this.contentOffsetY = this.contentOffsetY + event.movementY
    this.contentTarget.style.left = this.contentOffsetX + 'px'
    this.contentTarget.style.top = this.contentOffsetY + 'px'
    this.wasJustDragged = true
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

  _renderContet() {
    this.canvasTarget.width = this.scale * this.origWidth
    this.canvasTarget.height = this.scale * this.origHeight

    let ctx = this.canvasCtx

    createImageBitmap(this.imgData, {
      resizeWidth: this.canvasTarget.width,
      resizeHeight: this.canvasTarget.height,
      resizeQuality: "pixelated"
    }).then(bitMap => {
      ctx.drawImage(bitMap, 0, 0)
    })
  }

  _adjustCursor() {
    let size = this.scale - 2
    this.cursorTarget.style.width = size + 'px'
    this.cursorTarget.style.height = size + 'px'
    let visibility = 'hidden'
    if (this._cursorVisible()) {
      visibility = 'visible'
    }
    this.cursorTarget.style.visibility = visibility

    this._adjustCursorPosition()
  }

  _adjustCursorPosition() {
    let c = this._getCoordsByPixel(this.cursorPos)
    this.cursorTarget.style.left = (c.x + 2) + 'px'
    this.cursorTarget.style.top = (c.y + 2) + 'px'
  }

  _cursorVisible() {
    return this.scale >= CURSOR_MIN_SIZE + 2
  }

  _getPixelByCoords(offsetX, offsetY) {
    let row = Math.floor(offsetY / this.scale)
    let col = Math.floor(offsetX / this.scale)

    return { row, col }
  }

  _getCoordsByPixel({ row, col }) {
    return {
      x: this.scale * this.cursorPos.col,
      y: this.scale * this.cursorPos.row
    }
  }

  _postPixelChange(pos, hexColor) {
    let { row, col } = pos
    let color = hexColor.slice(1,7)

    return api.postJSON(this.pixelChangesUrlValue, { row, col, color })
  }

  _changePixel(pos, hexColor) {
    let color = hexToRGB(hexColor)
    let ctx = this.canvasCtx
    let pixelImageData = ctx.createImageData(1, 1)
    let offset = (pos.row * this.origWidth + pos.col) * 4
    for (let j = 0; j < 3; j++) {
      this.imgData.data[offset+j] = color[j]
      pixelImageData.data[j] = color[j]
    }
    pixelImageData.data[3] = 255

    let c = this._getCoordsByPixel(pos)

    createImageBitmap(pixelImageData, {
      resizeWidth: this.scale,
      resizeHeight: this.scale,
      resizeQuality: "pixelated"
    }).then(bitMap => {
      ctx.drawImage(bitMap, c.x, c.y)
    })
  }
}


function hexToRGB(hex) {
  return [1, 3, 5].map(offset => parseInt(hex.slice(offset, offset+2), 16))
}