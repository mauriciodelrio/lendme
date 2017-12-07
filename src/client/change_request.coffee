class cRequest
  constructor: () ->
    $.ajaxSetup cache: false
    @load_requests()
    @set_bindings()
    @requests = []
    @string_send = ''

  load_requests: () =>
    $.getJSON('/api/request/pending')
    .always (data) =>
      if data.status is 'OK' and data?.data
        @requests = data.data
        for request in data.data
          $('#req_choose').tmpl(
            id: request.req_id
            description: request.req_description
            date: moment(request.req_date).format 'YYYY-MM-DD'
            state: request.type_state_req_name
          ).appendTo ".request-results"
  
  set_bindings: () =>
    $('#c_request').submit @change_request

    $(document).on 'click', '.sel_req', (e) =>
      e.preventDefault()
      elem = $(e.currentTarget).attr 'id'
      _elem = elem.split '-'
      req_id = "req_id=#{_elem[1]}"
      console.log req_id
      @string_send = "#{req_id}"
      request = _.find @requests, (req) => return req.req_id = _elem[1]
      console.log request
      $("#req_choose").tmpl(
        id: request.req_id
        description: request.req_description
        date: moment(request.req_date).format 'YYYY-MM-DD'
        state: request.type_state_req_name
      ).appendTo ".request-selected"

  change_request: (e) =>
    e.preventDefault()
    opts = $(e.currentTarget).serialize()
    @string_send = "#{@string_send}&#{opts}"
    console.log @string_send
    $.post '/api/request/change', @string_send, (data) ->
      console.log data
      if data.status is 'OK' and data.data?
        alert data.data
      else
        console.log data
        alert data.data
    
window.cRequest = cRequest