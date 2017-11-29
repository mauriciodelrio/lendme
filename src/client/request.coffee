class Request
  constructor: (@requests) ->
    $.ajaxSetup cache: false
    @load_requests()

  load_requests: () ->
    console.log @requests
    for request in @requests
      $('#req_list').tmpl(
        description: @requests[request].req_description
        state: @requests[request].req_state
      ).appendTo ".listReq"

    
window.Request = Request