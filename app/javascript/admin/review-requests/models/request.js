export default function (request) {
  this.id = parseInt(request.id)

  Object.keys(request.attributes).forEach((key) => {
    this[key] = request.attributes[key]
  })

  this.isPending  = () => this.request_status === 'pending'
  this.isApproved = () => this.request_status === 'approved'
  this.isDeclined = () => this.request_status === 'declined'

  this.hasRequestStatus = (status) => this.request_status === status
}