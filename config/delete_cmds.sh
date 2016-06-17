#!/bin/bash
bin/rake db:rollback STEP=4
#bin/rails destroy scaffold DepatureMinute
#bin/rails destroy scaffold DepatureHour
#bin/rails destroy scaffold DayType
bin/rails destroy scaffold Departure
bin/rails destroy scaffold BusStop
bin/rails destroy scaffold Direction
bin/rails destroy scaffold BusLine