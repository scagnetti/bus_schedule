#!/bin/bash
bin/rails generate scaffold Line name:string
bin/rails generate scaffold Direction name:string line:references
bin/rails generate scaffold BusStop name:string direction:references
bin/rails generate scaffold Departure day_type:integer hour:integer minute:string bus_stop:references

#bin/rails generate scaffold DayType name:string bus_stop:references
#bin/rails generate scaffold DepatureHour h:integer day_type:references
#bin/rails generate scaffold DepatureMinute m:integer depature_hour:references
bin/rake db:migrate
