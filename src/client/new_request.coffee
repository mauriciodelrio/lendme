class NewRequest
  constructor: () ->
    $.ajaxSetup cache: false
    @load_requests()

  load_requests: () ->
    $.ajax(
      url: "/api/rew_request"
      type: 'get'
      data: params
    ).always (data) =>

    
window.NewRequest = NewRequest

