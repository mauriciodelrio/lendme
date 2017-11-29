class Request
  constructor: (@requests) ->
    $.ajaxSetup cache: false
    @load_requests()

  load_requests: () ->
    console.log @requests
    requests = JSON.parse @requests
    for request in requests or []
      $('#req_list').tmpl(
        description: request.req_description
        state: request.req_state
      ).appendTo ".listReq"

    
window.Request = Request