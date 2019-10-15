#!/usr/bin/gawk -f
# 
# For Release Notes and Scripts instructions see the main script EOSParser.sh
#
#PoweredBy: Julio Araujo
#ref: https://www.grymoire.com/Unix/Awk.html
#
BEGIN {

	#Default Variables.
	NO=0;
	YES=1;
	
	LineIx=0;
	JumpLineCNT=0;
	TrareFound=NO;

	EOSPointerCmp=NO;

	#Phases of script
	StartScript=0
	Phase=StartScript;	
	LoadRoutes=1;
	WaitTrace=2;
	LoadEOS=3;
	LoadSuccess=4;

	#This Variable sequence MUST be exactly the same as the TEST SYSTEM trace:
	#print AXEVARS;
	AXEVARS["027"]="EOS"
	HEAD[0]="027"
	AXEVARS["111"]="OBA"
	HEAD[1]="111"
	AXEVARS["13C"]="RC"
	HEAD[2]="13C"
	AXEVARS["02B"]="IROUTE"
	HEAD[3]="02B"
	AXEVARS["0CE"]="OROUTE"
	HEAD[4]="0CE"
	AXEVARS["14D"]="STYPE"
	HEAD[5]="14D"
	AXEVARS["196"]="TMRPRIMEUSED"
	HEAD[6]="196"
	AXEVARS["197"]="TMRPRIMEVALID"
	HEAD[7]="197"
	AXEVARS["114"]="ORIGROUTING"
	HEAD[8]="114"
	AXEVARS["007"]="BNRLASTPOS"
	HEAD[9]="007"
	AXEVARS["041"]="EMA"
	HEAD[10]="041"
	AXEVARS["004"]="A-NUMBER"
	HEAD[11]="004"
	AXEVARS["009"]="B-NUMBER"
	HEAD[12]="009"

	FileName = "";
}
{
	if (FileName != FILENAME) {
		if (STDOUT == YES ) { print "Loading...", FILENAME }
		FileName=FILENAME;
	}

        #	TRAN    STRVAR H'03C
	#H'00 0000:"0"
	#H'00 0001:"TCIA210"
	if ( index($0, "TRAN") > 0 && index($0, "STRVAR") > 0 ) {
		FS=":"
		getline;
		Phase=LoadRoutes;
	} else if (index($0, "END") > 0) {
		if ( Phase == LoadRoutes) {
			Phase=WaitTrace;
		}
	}

	if (Phase == LoadRoutes) {
		RoutePTR="0x"substr($1,6,4);
		RoutePTR=strtonum( RoutePTR );		
		StrRoute=$2;
		pattern="\"";
		gsub(pattern,"", StrRoute)
		if ( substr(StrRoute,1,1) != "0") {
			RouteName[RoutePTR]=StrRoute;
		}
	} else if (Phase == WaitTrace) {
		if ( index($0, "PROGRAM TRACING") > 0 ) {
			Phase = LoadEOS;
			JumpLineCNT=0;			
		}
		
	} else if (Phase == LoadEOS) {

		#Parse the EOS.....
		#Each TRACE sequence should be saved in the varibable Lines with semicolon between them
		#Sample of the result trace to be parsed
		#        TRARE   (B) VAR EOS
		#                    H'00 3982:H'027(H'0000)=H'005A
		#        TRARE   (B) VAR OBA
		#                    H'00 3982:H'111=H'006E
		#        TRARE   (B) VAR ROUTING_CASE
		#                    H'00 3982:H'13C=H'0096
		#        TRARE   (B) VAR ROTA_ENTRADA
		#                    H'00 3982:H'02B=H'0255
		#        TRARE   (B) VAR ROTA_SAIDA
		#                    H'00 3982:H'0CE=H'015A
		#        TRARE   (B) VAR STYPE
		#                    H'00 3982:H'14D=H'0000
		#        TRARE   (B) VAR H'00 3982:H'196=H'0000
		#        TRARE   (B) VAR H'00 3982:H'197=H'0000
		#        TRARE   (B) VAR H'00 3982:H'114=H'006E
		#        TRARE   (B) VAR H'00 3982:H'007=H'0010
		#        TRARE   (B) VAR EMERGENCY_AREA
		#                    H'00 3982:H'041=H'0000
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0001)=H'0001
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0002)=H'0001
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0003)=H'0005
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0004)=H'0000
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0005)=H'0004
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0006)=H'0005
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0007)=H'0001
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0008)=H'0007
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'0009)=H'0002
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'000A)=H'0000
		#        TRARE   (B) VAR ANR
		#                    H'00 3982:H'004(H'000B)=H'000F
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0001)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0002)=H'0008
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0003)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0004)=H'0005
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0005)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0006)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0007)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0008)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0009)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000A)=H'0009
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000B)=H'0007
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000C)=H'0004
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000D)=H'0009
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000E)=H'0005
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'000F)=H'0002
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0010)=H'0008
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0011)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0012)=H'0006
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0013)=H'0002
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0014)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0015)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0016)=H'0005
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0017)=H'0009
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0018)=H'0000
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'0019)=H'0004
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'001A)=H'0001
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'001B)=H'0009
		#        TRARE   (B) VAR BNR
		#                    H'00 3982:H'009(H'001C)=H'0001
		#        191009 095321 03
		if ( index($0, "TRARE") > 0 ) {
			JumpLineCNT = 0;

			if ( TrareFound == NO ) { TrareFound = YES }
			
			if ( index($0, "H'") == 0 ) {
				#If the variable was assigned a name then the information will be in the next line 
				getline;
			}


			EOSPos=index($1,"H'");
			EOSPointer[LineIx]=substr($1,EOSPos,9);
			#Check if the TRARE PR0 is the Same, if so skip the parser for this trace because it is the same.	
			if ( EOSPointer[LineIx] != EOSPointer[LineIx-1] ) {
				
				ValuePos=index($2,"=");
				AXEVarIx=substr($2,3,3);
			
				#Convert the HEX Value in to DEC.
				Value="0x"substr($2,ValuePos+3,4);
				Value=strtonum( Value );
			
				if ( index(AXEVARS[AXEVarIx],"A-NUMBER") > 0 ) {
					if ( BuildBNUM == YES ) {
						BuildBNUM=NO;
						Lines[LineIx]=Lines[LineIx]";";
					}
					Value=Lines[LineIx] Value;
					BuildANUM=YES;				
				} else if ( index(AXEVARS[AXEVarIx],"B-NUMBER") > 0 ) {
					if ( BuildANUM == YES ) {
						BuildANUM=NO;
						Lines[LineIx]=Lines[LineIx]";";
					}
					Value=Lines[LineIx] Value;
					BuildBNUM=YES;		
				} else {
					if ( BuildANUM == YES || BuildBNUM == YES  ) {
						BuildANUM=NO;
						BuildBNUM=NO;
						Lines[LineIx]=Lines[LineIx]";";
					}

					if ( index(AXEVARS[AXEVarIx],"ROUTE") > 0 ) {
						Value=RouteName[Value];
					}
				
					Value=Lines[LineIx] Value ";";
				
				}

				#Remove Carriage Return if exists.
				pattern="\r";		
				gsub(pattern,"", Value)
			
				Lines[LineIx]=Value;	
			}
		} else {
		
			if ( TrareFound == YES ) {
				TrareFound=NO;
				if ( JumpLineCNT == 0 ) {
					if ( EOSPointer[LineIx] != EOSPointer[LineIx-1] ) {
						LineIx++;
						JumpLineCNT++;
						BuildANUM=NO;
						BuildBNUM=NO;					
					}
				}
			}
			JumpLineCNT++;
		}

		#end of file.
		if ( NUMOFLINES == NR ) {
			Phase=LoadSuccess;
			exit;
		}
	}
} END {

	NLines=length(Lines);
	for (y=0;y<NLines;y++) { 
		if ( y == 0 ) {
			Value="";
			NHEAD=length(HEAD);
			for ( x = 0 ; x < NHEAD ; x++) { 
				Value=Value AXEVARS[HEAD[x]]";";
			}
			print Value;
		}	
		print Lines[y] 
	}

	if ( Phase == LoadSuccess ) {
		if (STDOUT == YES ) { print "Number of traces parsed: " NLines }
		
	} else if ( Phase == StartScript ) {
		print "Missing PRINT S TRAN 0-:60; to collect the routes Name";
		exit 1;
		
	} else if ( Phase == WaitTrace ) {
		print "Missing EOS TRACES, please check the file: "FileName;
		exit 2;
		
	} else {
		print "Fail to parse EOS Trace file: "FileName;
		exit 3;
	}
	#For test only
	#for (i in RouteName) { printf("Route Name = %s\n", RouteName[i]) }
	#for (x in AXEVARS) { print "AXEVARS["x"]="AXEVARS[x] }
	exit 0;
}


