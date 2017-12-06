class Request
  constructor: (@requests) ->
    $.ajaxSetup cache: false
    @load_requests()

  load_requests: () ->
    for request in @requests
      console.log request
      $('#req_list').tmpl(
        description: request.req_description
        date: moment(request.req_date).format 'YYYY-MM-DD'
        state: request.type_state_req_name
      ).appendTo ".listReq"

    
window.Request = Request