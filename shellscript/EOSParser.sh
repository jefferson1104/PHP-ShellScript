#!/bin/bash
#
# Script: Parser TRARE EOS Trace into csv file.
# Version: R1A.
#
# The following trace should be used to parser the informartion, this sample trace was done for MSS14B.
#
#TERM;
#CLEAR;
#ON V TRARE 39;
#ON V DO:IF V = 90,FOR 5000 TIMES,PRINT VAR;
#        PRINT V TRARE PR0:273;      !OBA=H'111!
#        PRINT V TRARE PR0:316;      !ROUTING_CASE=H'13C!
#        PRINT V TRARE PR0:43;       !IROUTE=H'02B!
#        PRINT V TRARE PR0:206;      !OROUTE=H'0CE!
#        PRINT V TRARE PR0:333;      !SUBSCRIPTIONTYPE=H'14D!
#        PRINT V TRARE PR0:406;      !TMRPRIMEUSED=H'196!
#        PRINT V TRARE PR0:407;      !TMRPRIMEVALID=H'197!
#        PRINT V TRARE PR0:276;      !ORIGROUTING=H'114!
#        PRINT V TRARE PR0:7;        !BNRLASTPOS=H'007!
#        PRINT V TRARE PR0:65;       !EMA=H'041!
#        PRINT V TRARE PR0:4(1-11);  !A-NUMBER=H'004!
#        PRINT V TRARE PR0:9(1-28);  !B-NUMBER=H'009!
#        PRINT TIME,; 
#PRINT S TRAN 0-:60; !TRANVAR=H'03C!
#
# Release Notes:
#	PA1
#	1. Building the basic structure to load the Route Name into an array variable.
#	2. Split the script into two scripts files, one Bash to load the default vars and the others to Parse the EOS Trace.
#	3. Building the AWK script to parse EOS Trace.
#	4. Create csv structure to output the information.
#	5. Concatenate A-NUM and B-NUM in a single field.
#	6. Insert the Route Name string insted of use the Global Route Number.
#	7. Insert the HEAD in the first line.
#	8. Insert gawk script file name and location inside a default Variable.
#	9. Remove EOSPTR Duplicate.
#	Close: 11/10/2019
#
#
#PoweredBy: Julio Araujo
#ref: https://www.grymoire.com/Unix/Awk.html
#09/out/2019

#Load the AXE Names and Values.
# This peace of code is to be used in the future to load the TRACE Variables for Block TRARE automatically from a text file.
#VarName[0]="TRAN";
#VarValue[0]="031";
#VarName[1]="EOS";
#VarValue[1]="027";
#VarName[2]="OBA";
#VarValue[2]="111";
#AxeVars=`cat axe_vars.txt`;
#for vars in ${AxeVars}; do
#	if [ -z $allvars ]; then
#		allvars=$vars;
#	else
#		allvars="${allvars};$vars"
#	fi
#done
#echo allvars=$allvars;

EOSParserAWKPath=`which EOSParser`
if [ $? == 0 ]; then
	AWKScriptFileName=$EOSParserAWKPath".awk"
else
	AWKScriptFileName="./EOSParser.awk";
fi
#echo $AWKScriptFileName;

#echo "NumOfArgs=$#";
if [ $# == 0 ]; then
	echo "Missing Input File!";
	exit 1;
elif [ $# == 2 ]; then
	OutputFileName=$2;
fi
InputFileName=$1;
if [ ! -f "$InputFileName" ]; then
	echo $InputFileName" File not found!";
	exit 1;
fi

NumOfLines=`cat $InputFileName | wc -l`
#echo "NumOfLines=$NumOfLines";

echo "Starting EOS Parser script..."
if [ -z $OutputFileName ]; then
	gawk -f $AWKScriptFileName -v NUMOFLINES=${NumOfLines} -v STDOUT=1 --non-decimal-data $InputFileName
else
	gawk -f $AWKScriptFileName -v NUMOFLINES=${NumOfLines} -v STDOUT=0 --non-decimal-data $InputFileName > ${OutputFileName}
fi
Result=$?
if [ $Result == 0 ]; then
	echo "Done!";
else
	exit $Result;
fi
exit 0;
#gawk -f EOSParser-pa1.awk `for i in {0..2}; do echo "-v ${VarName[$i]}=${VarValue[$i]}"; done` $InputFileName
#gawk -f EOSParser-pa1.awk -v AXEVARS=${allvars} -v NUMOFLINES=${NumOfLines} $InputFileName

