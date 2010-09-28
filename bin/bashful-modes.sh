#!/usr/bin/env bash

# Filename:      bashful-modes.sh
# Description:   Set of functions to interact with different script modes.
# Maintainer:    Jeremy Cantrell <jmcantrell@gmail.com>
# Last Modified: Mon 2010-09-27 20:30:31 (-0400)

# doc bashful-modes {{{
#
# The modes library provides functions for using getting/setting mode values.
#
# The modes are controlled by the following variables:
#
#     INTERACTIVE  # If unset/false, the user will not be prompted.
#     VERBOSE      # If unset/false, the user will not see notifications.
#
# The following commands get/set these variables:
#
#     interactive
#     verbose
#
# If called with no argument, it returns the state of the mode in question.
# If called with an argument, The mode is set to the value of the argument.
#
# The most common way that a mode would be set:
#
#     verbose ${VERBOSE:-1}
#
# This will set verbose mode to true if it is not already set.
#
# It can be used in the following way:
#
#     verbose && echo "Verbose mode is set!"
#
# doc-end bashful-modes }}}

if (( ${BASH_LINENO:-0} == 0 )); then
    source bashful-doc
    doc_execute "$0" "$@"
    exit
fi

[[ $BASHFUL_MODES_LOADED ]] && return

source bashful-core
source bashful-execute
source bashful-utils

interactive() #{{{1
{
    # doc interactive {{{
    #
    # With no arguments, test if interactive mode is enabled.
    # With one argument, set interactive mode to given value.
    #
    # Usage: interactive [VALUE]
    #
    # doc-end interactive }}}

    if (( $# == 0 )); then
        truth $INTERACTIVE && return 0
        return 1
    fi

    export INTERACTIVE=$(truth_value $1)
}

interactive_echo() #{{{1
{
    # doc interactive_echo {{{
    #
    # Will only echo the first argument if interactive mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: interactive_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # doc-end interactive_echo }}}

    truth_echo "$INTERACTIVE" "$1" "$2"
}

interactive_option() #{{{1
{
    # doc interactive_option {{{
    #
    # Echo the appropriate flag depending on the state of interactive mode.
    #
    # doc-end interactive_option }}}

    interactive_echo "-i" "-f"
}

verbose() #{{{1
{
    # doc verbose {{{
    #
    # With no arguments, test if verbose mode is enabled.
    # With one argument, set verbose mode to given value.
    #
    # Usage: verbose [VALUE]
    #
    # doc-end verbose }}}

    if (( $# == 0 )); then
        truth $VERBOSE && return 0
        return 1
    fi

    export VERBOSE=$(truth_value $1)
}

verbose_echo() #{{{1
{
    # doc verbose_echo {{{
    #
    # Will only echo the first argument if verbose mode is enabled.
    # Otherwise, echo the second argument.
    #
    # Usage: verbose_echo [TRUE_VALUE] [FALSE_VALUE]
    #
    # doc-end verbose_echo }}}

    truth_echo "$VERBOSE" "$1" "$2"
}

verbose_option() #{{{1
{
    # doc verbose_option {{{
    #
    # Echo the appropriate flag depending on the state of verbose mode.
    #
    # doc-end verbose_option }}}

    verbose_echo "-v" "-q"
}

verbose_execute() #{{{1
{
    # doc verbose_execute {{{
    #
    # Will execute the given command and only display the output if verbose
    # mode is enabled.
    #
    # Usage: verbose_execute [COMMAND]
    #
    # doc-end verbose_execute }}}

    if verbose; then
        execute "$@"
    else
        execute "$@" &>/dev/null
    fi
}

#}}}1
verbose_execute_in() #{{{1
{
    # doc verbose_execute_in {{{
    #
    # Will execute the given command in the given directory and only display
    # the output if verbose mode is enabled.
    #
    # Usage: verbose_execute_in DIRECTORY [COMMAND]
    #
    # doc-end verbose_execute_in }}}

    if verbose; then
        execute_in "$@"
    else
        execute_in "$@" &>/dev/null
    fi
}

#}}}1

BASHFUL_MODES_LOADED=1