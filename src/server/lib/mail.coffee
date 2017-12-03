CONFIG = require('../../../config').CONFIG
nodemailer = require 'nodemailer'

class Mail
  constructor: () ->

  send: (recipient, template, params = {}, cb) ->
    try
      if recipient and CONFIG?.MAIL?.SENDER_ADDRESS and CONFIG?.MAIL?.TEMPLATES?[template]?.text
        console.log "heeeeeeeeeeeere mail"
        text_message = CONFIG.MAIL.TEMPLATES[template].text
        html_message = CONFIG.MAIL.TEMPLATES[template].html
        subject = CONFIG.MAIL.TEMPLATES[template].subject or ''
        html_message = CONFIG.MAIL.TEMPLATES[template].html
        signature = CONFIG.MAIL.SIGNATURE or ''
        for param_key, param_value of params
          replaceable_key = new RegExp "\{\{#{param_key}\}\}", 'g'
          text_message = text_message.replace replaceable_key, param_value
          html_message = html_message.replace replaceable_key, param_value if html_message
        text_message += signature.replace('<br>', "\n").replace('<br />', "\n").replace('<br/>', "\n")
        html_message += signature.replace("\n", '<br />') if html_message
        configMail = 
          host: 'smtp.gmail.com'
          port: 587
          secure: false
          requireTLS: true
          auth:
            user: CONFIG?.MAIL?.GMAIL?.USERNAME
            pass: CONFIG?.MAIL?.GMAIL?.PASSWORD
        smtp_transport = nodemailer.createTransport configMail
        options =
          from: CONFIG?.MAIL?.SENDER_ADDRESS
          replyTo: CONFIG?.MAIL?.REPLY_ADDRESS or CONFIG?.MAIL?.SENDER_ADDRESS
          to: recipient
          subject: subject
          text: text_message
          html: html_message ? (text_message.replace /\n/g, '<br />')
          headers:
            'X-Mailer': 'LENDME-LEND-MLR-1.0'
        smtp_transport.sendMail options, (error, response) ->
          console.log error, response
          cb? error, response
    catch e
      cb? e, null

module.exports = Mail