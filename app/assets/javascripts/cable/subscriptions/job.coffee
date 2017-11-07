App.cable.subscriptions.create { channel: "JobChannel", job_id: "JOBID" },
  received: (data) ->
    console.log(data)
