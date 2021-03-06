#!/bin/bash

#  run-services - run gsatellite services

:<<COPYRIGHT

Copyright (C) 2012 Frank Scheiner
Copyright (C) 2013, 2014, 2016 Frank Scheiner, HLRS, Universitaet Stuttgart

The program is distributed under the terms of the GNU General Public License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

COPYRIGHT

umask 0077

_DEBUG="0"

_program=$( basename "$0" )

readonly _run_services_version="0.2.0"

export _notificationEmailAddress="$HOME/.gsatellite/myEmailAddress"

################################################################################
#  FUNCTIONS
################################################################################

#functionName()
#{
#	: #  do something...
#}
#
##  export function
#export -f functionName

__getEmailAddress()
{
	local _emailAddress=""
	
	# use user provided notifcation email address if existing...
	if [[ -e "$_notificationEmailAddress" && \
	      -s "$_notificationEmailAddress" ]]; then

		_emailAddress=$( cat "$_notificationEmailAddress" )
	
	# ...and if not (or if file is empty) just use local user name, which should direct mails to
	# the local account's mailbox.
	else
		_emailAddress=$( whoami )
	fi

	
	echo "$_emailAddress"
	
	return
}
export -f __getEmailAddress

################################################################################

_event="$1"

_environment="$2"

_servicesBaseDir="$3"

_jobExitValue="$4"

################################################################################

#  export event
export GSAT_EVENT="$_event"

if [[ "$_jobExitValue" != "" ]]; then

	export GSAT_JOB_EXIT_VALUE="$_jobExitValue"
fi

#  source environment
. "$_environment"

#  execute services
for _service in "$_servicesBaseDir"/*; do
        if [[ -x "$_service" && -r "$_service" ]]; then
                "$_service" &
        fi
done

exit

