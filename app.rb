# -*- coding: utf-8 -*-
require 'sinatra'
require 'eventmachine'
require 'pi_piper'
require 'mail'


# ------------------
GPIOPIN_LED = 23
GPIOPIN_BUZ = 24
SEC_LED = 259200
SEC_BUZ = 60
# ------------------


val = Hash.new
val['led'] = 0
val['buz'] = 0
val['accept'] = true

EM::defer do
  # countdown
  while true
    val['led'] -= 1 if val['led'] > 0
    val['buz'] -= 1 if val['buz'] > 0
    sleep 1
  end
end

EM::defer do
  pin_led = PiPiper::Pin.new(:pin => GPIOPIN_LED, :direction => :out)
  pin_buz = PiPiper::Pin.new(:pin => GPIOPIN_BUZ, :direction => :out)

  # flashing
  while true
    pin_led.on if val['led'] > 0
    pin_buz.on if val['buz'] > 0
    sleep 0.5

    pin_led.off
    pin_buz.off
    sleep 0.5
  end
end


# ------------------


get '/' do
  @val = val
  erb :"index"
end


post '/' do
  switch = params[:switch]

  if    switch == 'on'
    val['led'] = SEC_LED; val['buz'] = SEC_BUZ
  elsif switch == 'off'
    val['led'] = 0; val['buz'] = 0
  elsif switch == 'a_on'
    val['accept'] = true
  elsif switch == 'a_off'
    val['accept'] = false
  end

  @val = val
  erb :"index"
end


post '/nagios' do
  if val['accept']
    post_payload = request.body.read.to_s
    mail = Mail.new(post_payload)
    subject = mail.subject

    if    subject.scan(/is OK|is UP|Re:/).size != 0 then
      val['led'] = 0; val['buz'] = 0
    elsif subject.scan(/is WARNING|is UNKNOWN/).size != 0 then
      val['led'] = SEC_LED; val['buz'] = SEC_BUZ
    elsif subject.scan(/is CRITICAL/).size != 0 then
      val['led'] = SEC_LED; val['buz'] = SEC_BUZ
    elsif subject.scan(/is DOWN/).size != 0 then
      val['led'] = SEC_LED; val['buz'] = SEC_BUZ
    end
  end

  status 200
end

