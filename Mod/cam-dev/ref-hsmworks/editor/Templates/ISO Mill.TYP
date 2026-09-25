
## INIFILEVERSION #############################################################

[INIFILEVERSION]
VERSION		= 200

## GENERAL ####################################################################

[GENERAL]
DESCRIPTION	= ISO Milling
BASICTYPE	= 0
COLINDICATOR	= 60
HIDEASSIST	= No
LOADORDER	= 1

## RENUM ######################################################################

[RENUM]
AUTOINDENT	= Yes
UNDOLARGE	= No
INSERTSPACE	= 1
STARTNEXT	= No
RENUMEMPTY	= No
SHOWQUICK	= No
FORMAT		= 0
INTERVAL	= 1
START		= 100
FROM		= 0
TO		= 0
RESTART		= 0
RENUMCANNED	= No
PRECEEDESTR	= N
STARTTRIG	= 
SKIP		= %,O
SKIPCONTAIN	= 

## FILECOMPARE ################################################################

[FILECOMPARE]
SINGLESTEP	= Yes
IGNORECASE	= Yes
IGNOREBLOCK	= Yes
IGNORETNUMERIC	= Yes
IGNOREWHITESPACE= Yes
MARKCHANGEONLY	= Yes
TABSWITCH	= Yes
SMARTMARK	= Yes
AUTONEXT	= Yes
SHOWALL		= Yes

## LOADSAVE ###################################################################

[LOADSAVE]
AUTOSAVETIME	= 0
DIFFLOADSAVE	= No
REGDEFAULTEXT	= Yes
REGOTHEREXT	= Yes
SAVEEXT		= NC
LOADEXT		= NCL,ISO,NCF
LOADPATH	= 
SAVEPATH	= 

## MACHINETYPE ################################################################

[MACHINETYPE]
BLOCKSKIP	= /
COMMENTSTART	= (
COMMENTEND	= )
DECIMAL		= .
FEED		= F
SPEED		= S
TOOLCHANGE	= T
TOOLLOAD	= M6
PATHUNIT	= 0
FEEDUNIT	= 0
BLOCKSKIPAFTER	= Yes
RAPIDRATE	= 1000

## INSPECT ###################################################################

[INSPECT]
TURNPRG		= No
DIAPRG		= Yes
DIAARC		= No
AUTOX		= Yes
SHOWCYCLES	= Yes
NULLARCS	= Yes
PRINTQUALITY	= 2
TOOLTYPE	= 0
PRINTLOWCOLOR	= Yes
PRINTNOWCOLOR	= No
PLOTMODE	= 2
DRAWDIMMED	= Yes
SHOWTOOL	= Yes
SHOWRAPIDMOVES	= Yes
SHOWDOTS	= No
SHOWVECTORS	= No
HIGHLIGHTARCS	= Yes
NOPERSPECTIVE	= No
HIDEPLOTCTRL	= No
HIDECOORD	= No
TOOLDIA		= 

## CNCCALC ####################################################################

[CNCCALC]
ISTURN		= No
DECIMALS	= 3
TURNNEGATIVEX	= No
TURNDIAMETERPRG	= Yes
TURNDIAMETERARC	= Yes
ARCTYPE		= 1
GRIDON		= Yes
AXISON		= Yes
MODALXY		= No
MODALZ		= Yes
ALWAYSSIGN	= No
SHOWSUBGRID	= Yes
GRIDSIZE	= 10.000000
TRAILZEROS	= 0
METRICIMPERIAL	= 0
MACROHEAD	= 
MACROTAIL	= 
DRAWDIR		= 
ROTARYLINTOL = 0.010000
DEFAULTPOSTPROCESSORFILENAME = Posts\Mill\fanuc NO K.js

## NCBASE #####################################################################

[NCBASE]
GROUPS		= 
STORE		= No
ID		= 0

## COLORS #####################################################################

[COLORS]
USE		= 1
INBLOCK		= 1
USEMODALCOLORS	= 1
COUNT		= 30
COLOR0		= 0
COLOR1		= 16777215
COLOR2		= 65535
COLOR3		= 12582912
COLOR4		= 8388608
COLOR5		= 192
COLOR6		= 49152
COLOR7		= 12582912
COLOR8		= 12582912
COLOR9		= 16744576
COLOR19		= 255
COLOR10		= 16711935
COLOR11		= 0
COLOR12		= 8388736
COLOR13		= 8421504
COLOR14		= 16777215
COLOR15		= 65535
COLOR16		= 65535
COLOR17		= 3158064
COLOR18		= 8421504
COLOR20		= 0
COLOR21		= 16777215
COLOR22		= 12632256
COLOR23		= 11579568
COLOR24		= 57344
COLOR25		= 16777215
COLOR26		= 255
COLOR27		= 16711680
COLOR28		= 16777088
COLOR29		= 65535

## MACROINF ###################################################################

[MACROINF]
COUNT		= 94
CURRENT		= 0

## MACRO000 ###################################################################

[MACRO000]
NAME		= Program Start and End
HIDEFORMULAS	= No
TEXT		= %ÿ$1ÿ(-- $2 --)ÿG00 G17 G21 G40 G49 G80 G90ÿG91 G28 Z0.ÿ(-- $3 --)ÿ$4 M06ÿG00 G17 G90 $7 $8 $9 $6 M03ÿG43 $5 $10 M08ÿ(-- START MOTION --)ÿÿ(-- END MOTION --)ÿM09ÿM05ÿG91 G28 Z0.ÿG28 X0. Y0.ÿG90ÿM30ÿ%
PARAMCOUNT	= 10
000DESC		= Program number
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= O
000SUFFIX	= 
000MIN		= 1000
000MAX		= 6999
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2000
001DESC		= Program description
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= No
001NOEMPTYLINE	= No
001ALLOWALPHA	= Yes
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= 
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= 0
001DIGITS	= 0
001LASTVAL	= TEST
002DESC		= Tool description
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= Yes
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= 
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= 0
002DIGITS	= 0
002LASTVAL	= 10 FLAT
003DESC		= Tool number
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= T
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 1
004DESC		= Tool length offset number
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= H
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= 0
004DIGITS	= 0
004LASTVAL	= 1
005DESC		= Spindle speed
005REQUIRED	= Yes
005ISFUNC	= No
005USESIGN	= No
005UPPERCASE	= Yes
005ALLOWNEG	= No
005NOEMPTYLINE	= No
005ALLOWALPHA	= No
005REMEBER	= No
005DEFAULT	= 
005PREFIX	= S
005SUFFIX	= 
005MIN		= 
005MAX		= 
005DECIMALS	= 0
005DIGITS	= 0
005LASTVAL	= 200
006DESC		= Work offset
006REQUIRED	= Yes
006ISFUNC	= No
006USESIGN	= No
006UPPERCASE	= Yes
006ALLOWNEG	= Yes
006NOEMPTYLINE	= No
006ALLOWALPHA	= No
006REMEBER	= No
006DEFAULT	= 54
006PREFIX	= G
006SUFFIX	= 
006MIN		= 54
006MAX		= 59
006DECIMALS	= 0
006DIGITS	= 0
006LASTVAL	= 54
007DESC		= X rapid position
007REQUIRED	= Yes
007ISFUNC	= No
007USESIGN	= No
007UPPERCASE	= Yes
007ALLOWNEG	= Yes
007NOEMPTYLINE	= No
007ALLOWALPHA	= No
007REMEBER	= No
007DEFAULT	= 
007PREFIX	= X
007SUFFIX	= 
007MIN		= 
007MAX		= 
007DECIMALS	= -2
007DIGITS	= 0
007LASTVAL	= 0
008DESC		= Y rapid position
008REQUIRED	= Yes
008ISFUNC	= No
008USESIGN	= No
008UPPERCASE	= Yes
008ALLOWNEG	= Yes
008NOEMPTYLINE	= No
008ALLOWALPHA	= No
008REMEBER	= No
008DEFAULT	= 
008PREFIX	= Y
008SUFFIX	= 
008MIN		= 
008MAX		= 
008DECIMALS	= -2
008DIGITS	= 0
008LASTVAL	= 0
009DESC		= Z rapid position
009REQUIRED	= Yes
009ISFUNC	= No
009USESIGN	= No
009UPPERCASE	= Yes
009ALLOWNEG	= Yes
009NOEMPTYLINE	= No
009ALLOWALPHA	= No
009REMEBER	= No
009DEFAULT	= 
009PREFIX	= Z
009SUFFIX	= 
009MIN		= 
009MAX		= 
009DECIMALS	= -2
009DIGITS	= 0
009LASTVAL	= 0

## MACRO001 ###################################################################

[MACRO001]
NAME		= Tool change
HIDEFORMULAS	= No
TEXT		= M09ÿM05ÿG00 G91 G28 Z0.ÿM01ÿ(-- $1 --)ÿ$2 M06ÿG00 G17 G90 $5 $6 $7 $4 M03ÿG43 $3 $8 M08ÿ(-- START MOTION --)ÿÿ(-- END MOTION --)ÿ
PARAMCOUNT	= 8
000DESC		= Tool description
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= Yes
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= 
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 20 BALL
001DESC		= Tool number
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= No
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= T
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= 0
001DIGITS	= 0
001LASTVAL	= 2
002DESC		= Tool length offset number
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= H
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= 0
002DIGITS	= 0
002LASTVAL	= 2
003DESC		= Spindle speed
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= S
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 200
004DESC		= Work offset number
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 54
004PREFIX	= G
004SUFFIX	= 
004MIN		= 54
004MAX		= 59
004DECIMALS	= 0
004DIGITS	= 0
004LASTVAL	= 54
005DESC		= X rapid position
005REQUIRED	= Yes
005ISFUNC	= No
005USESIGN	= No
005UPPERCASE	= Yes
005ALLOWNEG	= Yes
005NOEMPTYLINE	= No
005ALLOWALPHA	= No
005REMEBER	= No
005DEFAULT	= 
005PREFIX	= X
005SUFFIX	= 
005MIN		= 
005MAX		= 
005DECIMALS	= -2
005DIGITS	= 0
005LASTVAL	= 0
006DESC		= Y rapid position
006REQUIRED	= Yes
006ISFUNC	= No
006USESIGN	= No
006UPPERCASE	= Yes
006ALLOWNEG	= Yes
006NOEMPTYLINE	= No
006ALLOWALPHA	= No
006REMEBER	= No
006DEFAULT	= 
006PREFIX	= Y
006SUFFIX	= 
006MIN		= 
006MAX		= 
006DECIMALS	= -2
006DIGITS	= 0
006LASTVAL	= 0
007DESC		= Z rapid position
007REQUIRED	= Yes
007ISFUNC	= No
007USESIGN	= No
007UPPERCASE	= Yes
007ALLOWNEG	= Yes
007NOEMPTYLINE	= No
007ALLOWALPHA	= No
007REMEBER	= No
007DEFAULT	= 
007PREFIX	= Z
007SUFFIX	= 
007MIN		= 
007MAX		= 
007DECIMALS	= -2
007DIGITS	= 0
007LASTVAL	= 0

## MACRO002 ###################################################################

[MACRO002]
NAME		= Program comment
HIDEFORMULAS	= No
TEXT		= (-- $1 --)
PARAMCOUNT	= 1
000DESC		= Program comment
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= Yes
000REMEBER	= Yes
000DEFAULT	= 
000PREFIX	= 
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -2
000DIGITS	= 0
000LASTVAL	= TEST

## MACRO003 ###################################################################

[MACRO003]
NAME		= G00 Rapid move
HIDEFORMULAS	= No
TEXT		= G00 $1 $2 $3
PARAMCOUNT	= 3
000DESC		= X coordinate
000REQUIRED	= No
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= 10
001DESC		= Y Coordinate
001REQUIRED	= No
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Y
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 100
002DESC		= Z coordinate
002REQUIRED	= No
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Z
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 100

## MACRO004 ###################################################################

[MACRO004]
NAME		= G01 Linear move
HIDEFORMULAS	= No
TEXT		= G01 $1 $2 $3
PARAMCOUNT	= 3
000DESC		= X coordinate
000REQUIRED	= No
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= 10
001DESC		= Y coordinate
001REQUIRED	= No
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Y
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Z coordinate
002REQUIRED	= No
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Z
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10

## MACRO005 ###################################################################

[MACRO005]
NAME		= G02 Clockwise arc move
HIDEFORMULAS	= No
TEXT		= G02 $1 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= X coordinate
000REQUIRED	= No
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= 10
001DESC		= Y coordinate
001REQUIRED	= No
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Y
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Z coordinate
002REQUIRED	= No
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Z
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Arc radius (set negative for arc sweep greater than 180 degrees)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= Yes
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= Yes
003DEFAULT	= 
003PREFIX	= R
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10

## MACRO006 ###################################################################

[MACRO006]
NAME		= G03 Counterclockwise arc move
HIDEFORMULAS	= No
TEXT		= G03 $1 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= X coordinate
000REQUIRED	= No
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= -44.
001DESC		= Y coordinate
001REQUIRED	= No
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Y
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 32.5
002DESC		= Z coordinate
002REQUIRED	= No
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Z
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 
003DESC		= Arc radius (set negative for arc sweep greater than 180 degrees)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= Yes
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= Yes
003DEFAULT	= 
003PREFIX	= R
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 2

## MACRO007 ###################################################################

[MACRO007]
NAME		= G04 Dwell
HIDEFORMULAS	= No
TEXT		= G04 $1
PARAMCOUNT	= 1
000DESC		= Dwell time (seconds)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= Yes
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= 2.0

## MACRO008 ###################################################################

[MACRO008]
NAME		= G07 Hypothetical axis interpolation
HIDEFORMULAS	= No
TEXT		= G07
PARAMCOUNT	= 0

## MACRO009 ###################################################################

[MACRO009]
NAME		= G09 Exact stop check for one block
HIDEFORMULAS	= No
TEXT		= G09
PARAMCOUNT	= 0

## MACRO010 ###################################################################

[MACRO010]
NAME		= G10 Data setting mode (Standard work offset registers)
HIDEFORMULAS	= No
TEXT		= G90 G10 L2 $1 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Work offset number (1=G54, 6=G59)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= Yes
000DEFAULT	= 1
000PREFIX	= P
000SUFFIX	= 
000MIN		= 1
000MAX		= 6
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2
001DESC		= X offset register
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= X
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10.0
002DESC		= Y offset register
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Y
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10.0
003DESC		= Z offset register
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= Yes
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= Z
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10.0

## MACRO011 ###################################################################

[MACRO011]
NAME		= G11 Data setting mode cancel
HIDEFORMULAS	= No
TEXT		= G11
PARAMCOUNT	= 0

## MACRO012 ###################################################################

[MACRO012]
NAME		= G15 Polar coordinate mode cancel
HIDEFORMULAS	= No
TEXT		= G15
PARAMCOUNT	= 0

## MACRO013 ###################################################################

[MACRO013]
NAME		= G16 Polar coordinate mode
HIDEFORMULAS	= No
TEXT		= G16
PARAMCOUNT	= 0

## MACRO014 ###################################################################

[MACRO014]
NAME		= G17 XY plane specification
HIDEFORMULAS	= No
TEXT		= G17
PARAMCOUNT	= 0

## MACRO015 ###################################################################

[MACRO015]
NAME		= G18 XZ plane specification
HIDEFORMULAS	= No
TEXT		= G18
PARAMCOUNT	= 0

## MACRO016 ###################################################################

[MACRO016]
NAME		= G19 YZ plane specification
HIDEFORMULAS	= No
TEXT		= G19
PARAMCOUNT	= 0

## MACRO017 ###################################################################

[MACRO017]
NAME		= G20 English units
HIDEFORMULAS	= No
TEXT		= G20
PARAMCOUNT	= 0

## MACRO018 ###################################################################

[MACRO018]
NAME		= G21 Metric units
HIDEFORMULAS	= No
TEXT		= G21
PARAMCOUNT	= 0

## MACRO019 ###################################################################

[MACRO019]
NAME		= G22 Stored stroke check ON
HIDEFORMULAS	= No
TEXT		= G22
PARAMCOUNT	= 0

## MACRO020 ###################################################################

[MACRO020]
NAME		= G23 Stored stroke check OFF
HIDEFORMULAS	= No
TEXT		= G23
PARAMCOUNT	= 0

## MACRO021 ###################################################################

[MACRO021]
NAME		= G25 Spindle speed fluctuation detection OFF
HIDEFORMULAS	= No
TEXT		= G25
PARAMCOUNT	= 0

## MACRO022 ###################################################################

[MACRO022]
NAME		= G26 Spindle speed fluctuation detection ON
HIDEFORMULAS	= No
TEXT		= G26
PARAMCOUNT	= 0

## MACRO023 ###################################################################

[MACRO023]
NAME		= G27 Machine zero return position check
HIDEFORMULAS	= No
TEXT		= G27
PARAMCOUNT	= 0

## MACRO024 ###################################################################

[MACRO024]
NAME		= G28 Machine zero return -primary reference point
HIDEFORMULAS	= No
TEXT		= G28
PARAMCOUNT	= 0

## MACRO025 ###################################################################

[MACRO025]
NAME		= G29 Return from machine zero
HIDEFORMULAS	= No
TEXT		= G29
PARAMCOUNT	= 0

## MACRO026 ###################################################################

[MACRO026]
NAME		= G30 Machine zero return secondary reference point
HIDEFORMULAS	= No
TEXT		= G30
PARAMCOUNT	= 0

## MACRO027 ###################################################################

[MACRO027]
NAME		= G31 Skip function
HIDEFORMULAS	= No
TEXT		= G31
PARAMCOUNT	= 0

## MACRO028 ###################################################################

[MACRO028]
NAME		= G33 Threading function
HIDEFORMULAS	= No
TEXT		= G33
PARAMCOUNT	= 0

## MACRO029 ###################################################################

[MACRO029]
NAME		= G37 Tool length automatic measurement
HIDEFORMULAS	= No
TEXT		= G37
PARAMCOUNT	= 0

## MACRO030 ###################################################################

[MACRO030]
NAME		= G40 Radius compensation off
HIDEFORMULAS	= No
TEXT		= G40
PARAMCOUNT	= 0

## MACRO031 ###################################################################

[MACRO031]
NAME		= G41 Radius compensation, left
HIDEFORMULAS	= No
TEXT		= G41 $1
PARAMCOUNT	= 1
000DESC		= Tool diameter register
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= Yes
000DEFAULT	= 
000PREFIX	= D
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2

## MACRO032 ###################################################################

[MACRO032]
NAME		= G42 Radius compensation, right
HIDEFORMULAS	= No
TEXT		= G42 $1
PARAMCOUNT	= 1
000DESC		= Tool diameter register
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= Yes
000DEFAULT	= 
000PREFIX	= D
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 3

## MACRO033 ###################################################################

[MACRO033]
NAME		= G43 Tool length offset - positive
HIDEFORMULAS	= No
TEXT		= G43 $1
PARAMCOUNT	= 1
000DESC		= Tool length register
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= H
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2

## MACRO034 ###################################################################

[MACRO034]
NAME		= G44 Tool length offset - negative
HIDEFORMULAS	= No
TEXT		= G44
PARAMCOUNT	= 0

## MACRO035 ###################################################################

[MACRO035]
NAME		= G45 Position compensation - single increase
HIDEFORMULAS	= No
TEXT		= G45
PARAMCOUNT	= 0

## MACRO036 ###################################################################

[MACRO036]
NAME		= G46 Position compensation - single decrease
HIDEFORMULAS	= No
TEXT		= G46
PARAMCOUNT	= 0

## MACRO037 ###################################################################

[MACRO037]
NAME		= G47 Position compensation - double increase
HIDEFORMULAS	= No
TEXT		= G47
PARAMCOUNT	= 0

## MACRO038 ###################################################################

[MACRO038]
NAME		= G48 Position compensation - double decrease
HIDEFORMULAS	= No
TEXT		= G48
PARAMCOUNT	= 0

## MACRO039 ###################################################################

[MACRO039]
NAME		= G49 Tool length offset cancel
HIDEFORMULAS	= No
TEXT		= G49
PARAMCOUNT	= 0

## MACRO040 ###################################################################

[MACRO040]
NAME		= G50 Scaling function mode cancel
HIDEFORMULAS	= No
TEXT		= G50
PARAMCOUNT	= 0

## MACRO041 ###################################################################

[MACRO041]
NAME		= G51 Scaling function mode
HIDEFORMULAS	= No
TEXT		= G51
PARAMCOUNT	= 0

## MACRO042 ###################################################################

[MACRO042]
NAME		= G52 Local coordinate system setting
HIDEFORMULAS	= No
TEXT		= G52
PARAMCOUNT	= 0

## MACRO043 ###################################################################

[MACRO043]
NAME		= G53 Machine coordinate system setting
HIDEFORMULAS	= No
TEXT		= G53
PARAMCOUNT	= 0

## MACRO044 ###################################################################

[MACRO044]
NAME		= G54 Work coordinate offset 1
HIDEFORMULAS	= No
TEXT		= G54
PARAMCOUNT	= 0

## MACRO045 ###################################################################

[MACRO045]
NAME		= G54.1 Additional work coordinate offset
HIDEFORMULAS	= No
TEXT		= G54.1 $1
PARAMCOUNT	= 1
000DESC		= Additional work offset (1=P1, 48=P48)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= P
000SUFFIX	= 
000MIN		= 1
000MAX		= 48
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2

## MACRO046 ###################################################################

[MACRO046]
NAME		= G55 Work coordinate offset 2
HIDEFORMULAS	= No
TEXT		= G55
PARAMCOUNT	= 0

## MACRO047 ###################################################################

[MACRO047]
NAME		= G56 Work coordinate offset 3
HIDEFORMULAS	= No
TEXT		= G56
PARAMCOUNT	= 0

## MACRO048 ###################################################################

[MACRO048]
NAME		= G57 Work coordinate offset 4
HIDEFORMULAS	= No
TEXT		= G57
PARAMCOUNT	= 0

## MACRO049 ###################################################################

[MACRO049]
NAME		= G58 Work coordinate offset 5
HIDEFORMULAS	= No
TEXT		= G58
PARAMCOUNT	= 0

## MACRO050 ###################################################################

[MACRO050]
NAME		= G59 Work coordinate offset 6
HIDEFORMULAS	= No
TEXT		= G59
PARAMCOUNT	= 0

## MACRO051 ###################################################################

[MACRO051]
NAME		= G60 Single direction positioning
HIDEFORMULAS	= No
TEXT		= G60
PARAMCOUNT	= 0

## MACRO052 ###################################################################

[MACRO052]
NAME		= G61 Exact stop mode
HIDEFORMULAS	= No
TEXT		= G61
PARAMCOUNT	= 0

## MACRO053 ###################################################################

[MACRO053]
NAME		= G62 Automatic corner override mode
HIDEFORMULAS	= No
TEXT		= G62
PARAMCOUNT	= 0

## MACRO054 ###################################################################

[MACRO054]
NAME		= G63 Tapping mode
HIDEFORMULAS	= No
TEXT		= G63
PARAMCOUNT	= 0

## MACRO055 ###################################################################

[MACRO055]
NAME		= G64 Cutting mode
HIDEFORMULAS	= No
TEXT		= G64
PARAMCOUNT	= 0

## MACRO056 ###################################################################

[MACRO056]
NAME		= G65 Custom macro call
HIDEFORMULAS	= No
TEXT		= G65
PARAMCOUNT	= 0

## MACRO057 ###################################################################

[MACRO057]
NAME		= G66 Custom macro modal call
HIDEFORMULAS	= No
TEXT		= G66
PARAMCOUNT	= 0

## MACRO058 ###################################################################

[MACRO058]
NAME		= G67 Custom macro modal call cancel
HIDEFORMULAS	= No
TEXT		= G67
PARAMCOUNT	= 0

## MACRO059 ###################################################################

[MACRO059]
NAME		= G68 Coordinate system rotation mode
HIDEFORMULAS	= No
TEXT		= G68 $1 $2 $3
PARAMCOUNT	= 3
000DESC		= X Center of rotation
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= X
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= 10
001DESC		= Y Center of rotation
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Y
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Angle of rotation
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= Yes
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10

## MACRO060 ###################################################################

[MACRO060]
NAME		= G69 Coordinate system rotation mode cancel
HIDEFORMULAS	= No
TEXT		= G69
PARAMCOUNT	= 0

## MACRO061 ###################################################################

[MACRO061]
NAME		= G73 Deep hole drilling cycle - high speed
HIDEFORMULAS	= No
TEXT		= $1 G73 $2 $3 $4 $5
PARAMCOUNT	= 5
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Peck amount
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= Q
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 110
004DESC		= Feedrate
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= F
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 1100

## MACRO062 ###################################################################

[MACRO062]
NAME		= G74 Left hand tapping cycle - standard M04
HIDEFORMULAS	= No
TEXT		= $1 G74 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10

## MACRO063 ###################################################################

[MACRO063]
NAME		= G76 Precision boring cycle
HIDEFORMULAS	= No
TEXT		= $1 G76 $2 $3 $4 $5 $6
PARAMCOUNT	= 6
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Dwell time milliseconds (P1000=1sec)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= P
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 100
004DESC		= Shift amount
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= Q
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 1
005DESC		= Feedrate
005REQUIRED	= Yes
005ISFUNC	= No
005USESIGN	= No
005UPPERCASE	= Yes
005ALLOWNEG	= No
005NOEMPTYLINE	= No
005ALLOWALPHA	= No
005REMEBER	= Yes
005DEFAULT	= 
005PREFIX	= F
005SUFFIX	= 
005MIN		= 
005MAX		= 
005DECIMALS	= -1
005DIGITS	= 0
005LASTVAL	= 10

## MACRO064 ###################################################################

[MACRO064]
NAME		= G80 Fixed cycle cancel
HIDEFORMULAS	= No
TEXT		= G80
PARAMCOUNT	= 0

## MACRO065 ###################################################################

[MACRO065]
NAME		= G81 Drilling cycle
HIDEFORMULAS	= No
TEXT		= $1 G81 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 100

## MACRO066 ###################################################################

[MACRO066]
NAME		= G82 Spot drilling cycle
HIDEFORMULAS	= No
TEXT		= $1 G82 $2 $3 $4 $5
PARAMCOUNT	= 5
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= -10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Dwell milliseconds at depth (P1000=1sec)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= P
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 10
004DESC		= Feedrate
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= F
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 100

## MACRO067 ###################################################################

[MACRO067]
NAME		= G83 Deep hole drilling cycle
HIDEFORMULAS	= No
TEXT		= $1 G83 $2 $3 $4 $5
PARAMCOUNT	= 5
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= -10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Peck amount
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= Q
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10
004DESC		= Feedrate
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= F
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 10

## MACRO068 ###################################################################

[MACRO068]
NAME		= G84 Right hand tapping cycle - standard M03
HIDEFORMULAS	= No
TEXT		= $1 G84 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10

## MACRO069 ###################################################################

[MACRO069]
NAME		= G85 Boring cycle
HIDEFORMULAS	= No
TEXT		= $1 G85 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10

## MACRO070 ###################################################################

[MACRO070]
NAME		= G86 Boring cycle
HIDEFORMULAS	= No
TEXT		= $1 G86 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 10

## MACRO071 ###################################################################

[MACRO071]
NAME		= G87 Back boring cycle
HIDEFORMULAS	= No
TEXT		= G98 G87 $1 $2 $3 $4
PARAMCOUNT	= 4
000DESC		= Z coordinate (absolute)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= Yes
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 
000PREFIX	= Z
000SUFFIX	= 
000MIN		= 
000MAX		= 
000DECIMALS	= -1
000DIGITS	= 0
000LASTVAL	= -10
001DESC		= Retract level (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= No
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= R
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Shift value
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= Q
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 1
003DESC		= Feedrate
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= F
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= -1
003DIGITS	= 0
003LASTVAL	= 100

## MACRO072 ###################################################################

[MACRO072]
NAME		= G88 Boring cycle
HIDEFORMULAS	= No
TEXT		= $1 G88 $2 $3 $4 $5
PARAMCOUNT	= 5
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Dwell time milliseconds (P1000=1sec)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= P
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 100
004DESC		= Feedrate
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= F
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 100

## MACRO073 ###################################################################

[MACRO073]
NAME		= G89 Boring cycle
HIDEFORMULAS	= No
TEXT		= $1 G89 $2 $3 $4 $5
PARAMCOUNT	= 5
000DESC		= Rapid retract (98=initial level, 99=R level)
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= No
000DEFAULT	= 98
000PREFIX	= G
000SUFFIX	= 
000MIN		= 98
000MAX		= 99
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 98
001DESC		= Z coordinate (absolute)
001REQUIRED	= Yes
001ISFUNC	= No
001USESIGN	= No
001UPPERCASE	= Yes
001ALLOWNEG	= Yes
001NOEMPTYLINE	= No
001ALLOWALPHA	= No
001REMEBER	= No
001DEFAULT	= 
001PREFIX	= Z
001SUFFIX	= 
001MIN		= 
001MAX		= 
001DECIMALS	= -1
001DIGITS	= 0
001LASTVAL	= 10
002DESC		= Retract level (absolute)
002REQUIRED	= Yes
002ISFUNC	= No
002USESIGN	= No
002UPPERCASE	= Yes
002ALLOWNEG	= No
002NOEMPTYLINE	= No
002ALLOWALPHA	= No
002REMEBER	= No
002DEFAULT	= 
002PREFIX	= R
002SUFFIX	= 
002MIN		= 
002MAX		= 
002DECIMALS	= -1
002DIGITS	= 0
002LASTVAL	= 10
003DESC		= Dwell time milliseconds (P1000=1sec)
003REQUIRED	= Yes
003ISFUNC	= No
003USESIGN	= No
003UPPERCASE	= Yes
003ALLOWNEG	= No
003NOEMPTYLINE	= No
003ALLOWALPHA	= No
003REMEBER	= No
003DEFAULT	= 
003PREFIX	= P
003SUFFIX	= 
003MIN		= 
003MAX		= 
003DECIMALS	= 0
003DIGITS	= 0
003LASTVAL	= 1000
004DESC		= Feedrate
004REQUIRED	= Yes
004ISFUNC	= No
004USESIGN	= No
004UPPERCASE	= Yes
004ALLOWNEG	= No
004NOEMPTYLINE	= No
004ALLOWALPHA	= No
004REMEBER	= No
004DEFAULT	= 
004PREFIX	= F
004SUFFIX	= 
004MIN		= 
004MAX		= 
004DECIMALS	= -1
004DIGITS	= 0
004LASTVAL	= 10

## MACRO074 ###################################################################

[MACRO074]
NAME		= G90 Absolute coordinates mode
HIDEFORMULAS	= No
TEXT		= G90
PARAMCOUNT	= 0

## MACRO075 ###################################################################

[MACRO075]
NAME		= G91 Incremental coordinates mode
HIDEFORMULAS	= No
TEXT		= G91
PARAMCOUNT	= 0

## MACRO076 ###################################################################

[MACRO076]
NAME		= G92 Coordinate system (tool position register)
HIDEFORMULAS	= No
TEXT		= G92
PARAMCOUNT	= 0

## MACRO077 ###################################################################

[MACRO077]
NAME		= G94 Feedrate per minute
HIDEFORMULAS	= No
TEXT		= G94
PARAMCOUNT	= 0

## MACRO078 ###################################################################

[MACRO078]
NAME		= G95 Feedrate per revolution
HIDEFORMULAS	= No
TEXT		= G95
PARAMCOUNT	= 0

## MACRO079 ###################################################################

[MACRO079]
NAME		= G98 Retract motion to initial level in fixed cycle
HIDEFORMULAS	= No
TEXT		= G98
PARAMCOUNT	= 0

## MACRO080 ###################################################################

[MACRO080]
NAME		= G99 Retract motion to R-level in fixed cycle
HIDEFORMULAS	= No
TEXT		= G99
PARAMCOUNT	= 0

## MACRO081 ###################################################################

[MACRO081]
NAME		= M00 Program stop
HIDEFORMULAS	= No
TEXT		= M00
PARAMCOUNT	= 0

## MACRO082 ###################################################################

[MACRO082]
NAME		= M01 Optional stop
HIDEFORMULAS	= No
TEXT		= M01
PARAMCOUNT	= 0

## MACRO083 ###################################################################

[MACRO083]
NAME		= M02 Program end
HIDEFORMULAS	= No
TEXT		= M02
PARAMCOUNT	= 0

## MACRO084 ###################################################################

[MACRO084]
NAME		= M03 Spindle start clockwise
HIDEFORMULAS	= No
TEXT		= M03
PARAMCOUNT	= 0

## MACRO085 ###################################################################

[MACRO085]
NAME		= M04 Spindle start counter-clockwise
HIDEFORMULAS	= No
TEXT		= M04
PARAMCOUNT	= 0

## MACRO086 ###################################################################

[MACRO086]
NAME		= M05 Spindle stop
HIDEFORMULAS	= No
TEXT		= M05
PARAMCOUNT	= 0

## MACRO087 ###################################################################

[MACRO087]
NAME		= M06 Automatic tool change
HIDEFORMULAS	= No
TEXT		= M06
PARAMCOUNT	= 0

## MACRO088 ###################################################################

[MACRO088]
NAME		= M07 Coolant mist on
HIDEFORMULAS	= No
TEXT		= M07
PARAMCOUNT	= 0

## MACRO089 ###################################################################

[MACRO089]
NAME		= M08 Coolant on
HIDEFORMULAS	= No
TEXT		= M08
PARAMCOUNT	= 0

## MACRO090 ###################################################################

[MACRO090]
NAME		= M09 Coolant off
HIDEFORMULAS	= No
TEXT		= M09
PARAMCOUNT	= 0

## MACRO091 ###################################################################

[MACRO091]
NAME		= M30 End of program with reset and rewind
HIDEFORMULAS	= No
TEXT		= M30
PARAMCOUNT	= 0

## MACRO092 ###################################################################

[MACRO092]
NAME		= M98 Subprogram call
HIDEFORMULAS	= No
TEXT		= M98 $1
PARAMCOUNT	= 1
000DESC		= Subprogram number
000REQUIRED	= Yes
000ISFUNC	= No
000USESIGN	= No
000UPPERCASE	= Yes
000ALLOWNEG	= No
000NOEMPTYLINE	= No
000ALLOWALPHA	= No
000REMEBER	= Yes
000DEFAULT	= 
000PREFIX	= P
000SUFFIX	= 
000MIN		= 1000
000MAX		= 6999
000DECIMALS	= 0
000DIGITS	= 0
000LASTVAL	= 2000

## MACRO093 ###################################################################

[MACRO093]
NAME		= M99 Subprogram end or Macro end
HIDEFORMULAS	= No
TEXT		= M99
PARAMCOUNT	= 0
