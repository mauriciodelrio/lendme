class Request
  constructor: (@requests) ->
    $.ajaxSetup cache: false
    @load_requests()

  load_requests: () ->
    for request in @requests
      console.log request
      $('#req_list').tmpl(
        description: request.req_description
        state: request.req_state
      ).appendTo ".listReq"

    
window.Request = Request