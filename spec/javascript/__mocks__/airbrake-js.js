class AirbrakeClient {

  constructor(options) {
    this.options = options;
  }

  notify(options) {
    // noop - we don't want this notifying airbrake on errors
  }

}

export default AirbrakeClient;