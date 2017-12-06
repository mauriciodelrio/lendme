class NewRequest
  constructor: () ->
    $.ajaxSetup cache: false
    @set_bindings()
    @req_params = null
    @init()
  
  init: () ->
    $.getJSON('/api/request/interval')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for interval in data.data or []
          $('#time_interval').tmpl(
            id: interval.time_id
            name: interval.time_name
          ).appendTo "#bloque"

    $.getJSON('/api/request/type_request')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for t_req in data.data or []
          $('#req_type').tmpl(
            id: t_req.type_req_id
            name: t_req.type_req_name
          ).appendTo "#tipo_solicitud"

    $.getJSON('/api/request/type_space')
    .always (data) ->
      if data.status is 'OK' and data?.data
        for t_spa in data.data or []
          $('#spa_type').tmpl(
            id: t_spa.type_spa_id
            name: t_spa.type_spa_name
          ).appendTo "#tipo_espacio"
    
  set_bindings: () ->
    $('#filter').submit @load_spaces_preferences

    $('#confirm_request').submit @new_request

    $(document).on 'click', '.sel_space', (e) =>
      e.preventDefault()
      elem = $(e.currentTarget).attr 'id'
      _elem = elem.split '-'
      spa_id = "spa_id=#{_elem[1]}"
      $.get '/api/request/options', spa_id, (data) =>
        if data.status is 'OK' and data.data
          $('#conf_button').prop 'disabled', false
          $('.sel_space').prop 'disabled', true
          @req_params = "#{@req_params}&#{spa_id}"
          for option in data.data or []
            $('#options').tmpl(
              name: option.opt_name
              id: option.opt_id
            ).appendTo "#opts"

  new_request: (e) =>
    e.preventDefault()
    opts = $(e.currentTarget).serialize()
    @req_params = "#{@req_params}&#{opts}"
    $.post '/api/request', @req_params, (data) ->
      if data.status is 'OK' and data.data?
        alert data.data
        window.location.href = '/dashboard'
      else
        alert data.data
        location.reload()

  load_spaces_preferences: (e) =>
    e.preventDefault()
    params = $(e.currentTarget).serialize()
    $.get '/api/request/spaces', params, (data) =>
      if data.status is 'OK' and data.data
        for space in data.data or []
          $('#spaces_disp').tmpl(
            id: space.spa_id
            name: space.spa_name
            description: space.spa_description
            reference: space.spa_reference
            capacity: space.spa_capacity
          ).appendTo ".spaces-results"
        @req_params = params
      else
        console.log data.message
    
window.NewRequest = NewRequest

