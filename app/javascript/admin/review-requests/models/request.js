export default function (request) {
  this.id = parseInt(request.id)

  Object.keys(request.attributes).forEach((key) => {
    this[key] = request.attributes[key]
  })
}