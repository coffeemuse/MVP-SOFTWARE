//HERC01  JOB  (CBT),
//             'LOAD CBT129',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(0,0),
//             NOTIFY=HERC01,
//             REGION=4096K
//********************************************************************
//*                                                                  *
//* Name: CBT.MVS38J.CNTL(CBT090)                                    *
//*                                                                  *
//* Desc: Drop down files from cbt tape 129                          *
//*                                                                  *
//* Note: The actual jobsteps begin after the line containing        *
//*       the string >>>>>>>>>>>>>>>>>>>>                            *
//*                                                                  *
//********************************************************************
//COPY   PROC  V1=CBT129,          INPUT TAPE VOLUME
//             VO=CBTCAT,          OUTPUT DASD VOLUME
//             LAB=,               INPUT TAPE LABEL NUMBER
//             CLASS='*',          SYSOUT CLASS
//             WORK1=3350,         DASD OUTPUT TYPE
//             WORK2=3350,         DASD WORK TYPE
//             INDEX=CBT129,       FIRST LEVEL INDEX FOR DSNAME
//             DSP='CATLG,DELETE', OUTPUT DATASET DISPOSITION
//             UNT=TAPE,           TYPE UNIT NAME
//             TY=NL,              TAPE FILE LABEL
//             PRI=190,            PRIMARY ALLOCATION
//             SEC=190,            SECONDARY ALLOCATION
//             DIR=56,             NUMBER OF DIRECTORY BLOCKS
//             ALLOC=TRK           ALLOC INCREMENT
//COPY    EXEC PGM=IEBCOPY,REGION=256K,COND=EVEN
//SYSPRINT DD  SYSOUT=&CLASS
//SYSUT3   DD  SPACE=(CYL,(10,10)),UNIT=&WORK2
//SYSUT4   DD  SPACE=(CYL,(10,10)),UNIT=&WORK2
//SYSUT1   DD  UNIT=&UNT,VOL=SER=&V1,DISP=(OLD,PASS),
//             LABEL=(&LAB,&TY.)
//SYSUT2   DD  DSN=&INDEX..FILE&LAB,DISP=(NEW,&DSP.),
//             UNIT=&WORK1.,FREE=CLOSE,
//             SPACE=(&ALLOC.,(&PRI.,&SEC.,&DIR.),RLSE),VOL=SER=&VO
//SYSIN    DD  DUMMY
//       PEND
//GENERO PROC  V1=CBT129,          INPUT TAPE VOLUME
//             VO=CBTCAT,          OUTPUT DASD VOLUME
//             LAB=,               INPUT TAPE LABEL NUMBER
//             CLASS='*',          SYSOUT CLASS
//             WORK1=3350,         DASD OUTPUT TYPE
//             INDEX=CBT129,       FIRST LEVEL INDEX FOR DSNAME
//             DSP='CATLG,DELETE', OUTPUT DATASET DISPOSITION
//             UNT=TAPE,           TYPE UNIT NAME
//             TY=NL,              TAPE FILE LABEL
//             PRI=190,            PRIMARY ALLOCATION
//             SEC=190,            SECONDARY ALLOCATION
//             ALLOC=TRK,          ALLOC INCREMENT
//             LR=80,              LRECL
//             BKI=32720,          INPUT BLOCKSIZE
//             BKO=5600,           OUTPUT BLOCKSIZE
//             FM=FB               RECFM
//GENER    EXEC  PGM=IEBGENER,REGION=256K,COND=EVEN
//SYSPRINT DD  SYSOUT=&CLASS
//SYSUT1   DD  UNIT=&UNT,VOL=SER=&V1,DISP=(OLD,PASS),
//             DCB=(RECFM=&FM.,LRECL=&LR.,BLKSIZE=&BKI.),
//             LABEL=(&LAB,&TY.)
//SYSUT2   DD  DSN=&INDEX..FILE&LAB,DISP=(NEW,&DSP.),
//             UNIT=&WORK1.,FREE=CLOSE,
//             DCB=(RECFM=&FM.,LRECL=&LR.,BLKSIZE=&BKO.),
//             SPACE=(&ALLOC.,(&PRI.,&SEC.),RLSE),VOL=SER=&VO
//SYSIN    DD  DUMMY
//       PEND
//UPDATEO PROC V1=CBT129,          INPUT TAPE VOLUME
//             VO=CBTCAT,          OUTPUT DASD VOLUME
//             LAB=,               INPUT TAPE LABEL NUMBER
//             CLASS='*',          SYSOUT CLASS
//             WORK1=SYSDA,        DASD OUTPUT TYPE
//             INDEX=CBT129,       FIRST LEVEL INDEX FOR DSNAME
//             DSP='CATLG,DELETE', OUTPUT DATASET DISPOSITION
//             UNT=TAPE,           TYPE UNIT NAME
//             TY=NL,              TAPE FILE LABEL
//             PRI=190,            PRIMARY ALLOCATION
//             SEC=190,            SECONDARY ALLOCATION
//             DIR=56,             NUMBER OF DIRECTORY BLOCKS
//             ALLOC=TRK,          ALLOC INCREMENT
//             LR=80,              LRECL
//             BKI=32720,          INPUT BLOCKSIZE
//             BKO=5600,           OUTPUT BLOCKSIZE
//             FM=FB               RECFM
//UPDATE   EXEC  PGM=IEBUPDTE,PARM=NEW,REGION=256K,COND=EVEN
//SYSPRINT DD  SYSOUT=&CLASS
//SYSIN    DD  UNIT=&UNT,VOL=SER=&V1,DISP=(OLD,PASS),
//             DCB=(RECFM=&FM.,LRECL=&LR.,BLKSIZE=&BKI.),
//             LABEL=(&LAB,&TY.)
//SYSUT2   DD  DSN=&INDEX..FILE&LAB,DISP=(NEW,&DSP.),
//             UNIT=&WORK1.,FREE=CLOSE,
//             DCB=(RECFM=&FM.,LRECL=&LR.,BLKSIZE=&BKO.),
//             SPACE=(&ALLOC.,(&PRI.,&SEC.,&DIR.),RLSE),VOL=SER=&VO
//       PEND
//GENER  PROC  V1=CBT129,          INPUT TAPE VOLUME
//             VO=CBTCAT,          OUTPUT DASD VOLUME
//             P=CBT973,           DECOMPRESSION PROGRAM
//             LAB=,               INPUT TAPE LABEL NUMBER
//             WORK1=3350,         DASD OUTPUT TYPE
//             INDEX=CBT129,       FIRST LEVEL INDEX FOR DSNAME
//             DSP='CATLG,DELETE', OUTPUT DATASET DISPOSITION
//             UNT=TAPE,           TYPE UNIT NAME
//             TY=NL,              TAPE FILE LABEL
//             PRI=190,            PRIMARY ALLOCATION
//             SEC=190,            SECONDARY ALLOCATION
//             ALLOC=TRK,          ALLOC INCREMENT
//             LR=80,              LRECL
//             BKI=32716,          INPUT BLOCKSIZE
//             BKO=5600,           OUTPUT BLOCKSIZE
//             FM=FB               RECFM
//GENER    EXEC  PGM=&P,REGION=512K,COND=EVEN
//INPUT    DD  UNIT=&UNT,VOL=SER=&V1,DISP=(OLD,PASS),
//             DCB=(RECFM=VB,LRECL=94,BLKSIZE=&BKI.),
//             LABEL=(&LAB,&TY.)
//OUTPUT   DD  DSN=&INDEX..FILE&LAB,DISP=(NEW,&DSP.),
//             UNIT=&WORK1.,FREE=CLOSE,
//             DCB=(RECFM=&FM.,LRECL=&LR.,BLKSIZE=&BKO.),
//             SPACE=(&ALLOC.,(&PRI.,&SEC.),RLSE),VOL=SER=&VO
//       PEND
//*>>>>>>>>>>>>>>>>>>>>>>>>> beginning of jobsteps <<<<<<<<<<<<<<<<<<<
//STEP001     EXEC GENERO,LAB=001
//STEP002     EXEC GENERO,LAB=002
//STEP003     EXEC GENERO,LAB=003
//STEP004     EXEC GENER,LAB=004
//STEP005     EXEC GENER,LAB=005
//STEP006     EXEC GENER,LAB=006
//STEP007     EXEC GENER,LAB=007
//STEP008     EXEC GENER,LAB=008
//STEP009     EXEC GENER,LAB=009
//STEP027     EXEC GENER,LAB=027
//STEP028     EXEC GENER,LAB=028
//STEP029     EXEC GENER,LAB=029
//STEP030     EXEC GENER,LAB=030
//STEP031     EXEC GENER,LAB=031
//STEP032     EXEC GENER,LAB=032,FM=FBA
//STEP033     EXEC GENER,LAB=033
//STEP034     EXEC GENER,LAB=034
//STEP035     EXEC COPY,LAB=035
//STEP040     EXEC COPY,LAB=040
//STEP041     EXEC GENER,LAB=041
//STEP042     EXEC GENER,LAB=042
//STEP043     EXEC GENERO,LAB=043,FM=FB,LR=133,BKI=32718,BKO=6118
//STEP044     EXEC COPY,LAB=044
//STEP045     EXEC GENER,LAB=045,FM=FBA
//STEP046     EXEC GENER,LAB=046
//STEP047     EXEC GENER,LAB=047
//STEP048     EXEC GENER,LAB=048
//STEP049     EXEC GENER,LAB=049
//STEP050     EXEC GENER,LAB=050
//STEP051     EXEC GENER,LAB=051
//STEP052     EXEC GENER,LAB=052
//STEP053     EXEC GENER,LAB=053
//STEP054     EXEC GENER,LAB=054
//STEP055     EXEC GENER,LAB=055
//STEP056     EXEC GENER,LAB=056
//STEP057     EXEC GENER,LAB=057,FM=FBA
//STEP058     EXEC COPY,LAB=058
//STEP059     EXEC GENERO,LAB=059,FM=VBA,LR=137,BKI=32747,BKO=6136
//STEP060     EXEC GENER,LAB=060
//STEP061     EXEC GENER,LAB=061
//STEP062     EXEC GENER,LAB=062
//STEP063     EXEC GENER,LAB=063
//STEP064     EXEC COPY,LAB=064
//STEP065     EXEC COPY,LAB=065
//STEP066     EXEC COPY,LAB=066
//STEP067     EXEC COPY,LAB=067
//STEP068     EXEC COPY,LAB=068
//STEP069     EXEC COPY,LAB=069
//STEP070     EXEC GENER,LAB=070
//STEP071     EXEC GENER,LAB=071
//STEP072     EXEC GENER,LAB=072
//STEP073     EXEC GENER,LAB=073
//STEP074     EXEC GENERO,LAB=074,FM=FBA,LR=133,BKI=32718,BKO=6118
//STEP075     EXEC GENER,LAB=075
//STEP076     EXEC GENER,LAB=076
//STEP077     EXEC GENER,LAB=077,FM=FBA
//STEP078     EXEC GENER,LAB=078
//STEP079     EXEC GENER,LAB=079
//STEP080     EXEC GENER,LAB=080
//STEP081     EXEC GENER,LAB=081
//STEP082     EXEC GENER,LAB=082,FM=FBA
//STEP083     EXEC GENER,LAB=083
//STEP084     EXEC GENER,LAB=084
//STEP085     EXEC GENER,LAB=085
//STEP086     EXEC GENER,LAB=086
//STEP087     EXEC GENER,LAB=087
//STEP088     EXEC COPY,LAB=088
//STEP089     EXEC GENER,LAB=089
//STEP090     EXEC GENER,LAB=090
//STEP091     EXEC GENER,LAB=091
//STEP092     EXEC GENERO,LAB=092,FM=FBM,LR=133,BKI=32718,BKO=6118
//STEP093     EXEC GENERO,LAB=093,FM=FBA,LR=133,BKI=32718,BKO=6118
//STEP094     EXEC GENER,LAB=094
//STEP095     EXEC GENER,LAB=095
//STEP096     EXEC GENER,LAB=096
//STEP097     EXEC GENER,LAB=097
//STEP098     EXEC GENER,LAB=098
//STEP099     EXEC GENER,LAB=099
//STEP100     EXEC GENER,LAB=100
//STEP101     EXEC GENER,LAB=101
//STEP102     EXEC GENER,LAB=102
//STEP103     EXEC GENER,LAB=103
//STEP104     EXEC GENERO,LAB=104,FM=FBM,LR=133,BKI=32718,BKO=6118
//STEP105     EXEC GENER,LAB=105
//STEP106     EXEC GENER,LAB=106
//STEP107     EXEC GENER,LAB=107
//STEP108     EXEC GENER,LAB=108
//STEP109     EXEC GENER,LAB=109
//STEP110     EXEC GENER,LAB=110
//STEP111     EXEC GENERO,LAB=111,FM=FBM,LR=133,BKI=32718,BKO=6118
//STEP112     EXEC GENER,LAB=112
//STEP113     EXEC GENER,LAB=113
//STEP114     EXEC GENERO,LAB=114,FM=FBA,LR=133,BKI=32718,BKO=6118
//STEP115     EXEC GENER,LAB=115
//STEP117     EXEC GENER,LAB=117
//STEP118     EXEC GENER,LAB=118
//STEP119     EXEC GENER,LAB=119
//STEP127     EXEC GENER,LAB=127
//STEP128     EXEC GENER,LAB=128
//STEP129     EXEC COPY,LAB=129
//STEP130     EXEC GENER,LAB=130,FM=FBA
//STEP131     EXEC GENER,LAB=131
//STEP132     EXEC GENER,LAB=132
//STEP133     EXEC GENER,LAB=133
//STEP134     EXEC GENER,LAB=134
//STEP135     EXEC GENER,LAB=135
//STEP136     EXEC GENERO,LAB=136,FM=FBA,LR=133,BKI=32718,BKO=6118
//STEP137     EXEC GENER,LAB=137
//STEP138     EXEC GENER,LAB=138
//STEP139     EXEC GENER,LAB=139
//STEP140     EXEC GENER,LAB=140
//STEP141     EXEC GENER,LAB=141
//STEP142     EXEC GENER,LAB=142
//STEP143     EXEC GENER,LAB=143 TYPE=CLIST
//STEP144     EXEC GENER,LAB=144
//STEP145     EXEC GENER,LAB=145
//STEP146     EXEC GENER,LAB=146
//STEP147     EXEC GENER,LAB=147
//STEP148     EXEC GENER,LAB=148
//STEP149     EXEC GENER,LAB=149
//STEP150     EXEC GENER,LAB=150
//STEP151     EXEC GENER,LAB=151
//STEP152     EXEC GENER,LAB=152
//STEP153     EXEC GENER,LAB=153
//STEP154     EXEC GENER,LAB=154
//STEP155     EXEC GENER,LAB=155,FM=FBM
//STEP156     EXEC GENER,LAB=156
//STEP157     EXEC GENER,LAB=157
//STEP158     EXEC GENER,LAB=158
//STEP159     EXEC GENER,LAB=159
//STEP160     EXEC GENER,LAB=160
//STEP161     EXEC GENER,LAB=161
//STEP162     EXEC GENER,LAB=162
//STEP163     EXEC GENER,LAB=163
//STEP164     EXEC GENER,LAB=164
//STEP165     EXEC GENER,LAB=165
//STEP166     EXEC GENER,LAB=166
//STEP167     EXEC GENER,LAB=167
//STEP168     EXEC GENER,LAB=168
//STEP169     EXEC GENER,LAB=169
//STEP170     EXEC GENER,LAB=170
//STEP171     EXEC COPY,LAB=171
//STEP172     EXEC GENER,LAB=172,FM=FBA
//STEP173     EXEC GENER,LAB=173
//STEP174     EXEC GENER,LAB=174
//STEP175     EXEC GENER,LAB=175
//STEP176     EXEC GENER,LAB=176
//STEP177     EXEC GENER,LAB=177
//STEP178     EXEC GENER,LAB=178
//STEP179     EXEC GENER,LAB=179
//STEP180     EXEC GENER,LAB=180
//STEP181     EXEC GENER,LAB=181
//STEP182     EXEC GENER,LAB=182
//STEP183     EXEC GENER,LAB=183
//STEP184     EXEC GENER,LAB=184
//STEP185     EXEC GENER,LAB=185
//STEP186     EXEC GENER,LAB=186
//STEP188     EXEC GENER,LAB=188
//STEP189     EXEC GENER,LAB=189
//STEP190     EXEC GENER,LAB=190
//STEP191     EXEC GENER,LAB=191
//STEP192     EXEC GENER,LAB=192
//STEP193     EXEC GENER,LAB=193
//STEP194     EXEC GENER,LAB=194
//STEP195     EXEC GENER,LAB=195
//STEP196     EXEC GENER,LAB=196
//STEP197     EXEC GENER,LAB=197
//STEP198     EXEC GENER,LAB=198
//STEP199     EXEC GENER,LAB=199
//STEP200     EXEC COPY,LAB=200
//STEP201     EXEC GENER,LAB=201
//STEP202     EXEC GENER,LAB=202
//STEP203     EXEC GENER,LAB=203
//STEP204     EXEC GENER,LAB=204
//STEP205     EXEC GENER,LAB=205
//STEP206     EXEC GENER,LAB=206
//STEP207     EXEC GENER,LAB=207
//STEP208     EXEC GENER,LAB=208
//STEP209     EXEC GENER,LAB=209
//STEP210     EXEC GENER,LAB=210
//STEP211     EXEC GENER,LAB=211
//STEP212     EXEC GENER,LAB=212
//STEP213     EXEC GENER,LAB=213
//STEP214     EXEC GENER,LAB=214,FM=FBA
//STEP215     EXEC GENER,LAB=215
//STEP216     EXEC GENER,LAB=216
//STEP217     EXEC GENER,LAB=217
//STEP218     EXEC GENER,LAB=218
//STEP219     EXEC GENER,LAB=219
//STEP220     EXEC GENER,LAB=220
//STEP221     EXEC GENER,LAB=221
//STEP222     EXEC GENER,LAB=222
//STEP223     EXEC GENER,LAB=223
//STEP224     EXEC GENER,LAB=224
//STEP225     EXEC GENER,LAB=225
//STEP226     EXEC GENER,LAB=226
//STEP227     EXEC GENER,LAB=227
//STEP228     EXEC GENER,LAB=228
//STEP229     EXEC GENER,LAB=229
//STEP230     EXEC GENER,LAB=230
//STEP231     EXEC GENER,LAB=231
//STEP232     EXEC GENER,LAB=232
//STEP233     EXEC GENER,LAB=233
//STEP234     EXEC GENER,LAB=234
//STEP235     EXEC GENER,LAB=235
//STEP236     EXEC GENER,LAB=236
//STEP237     EXEC GENER,LAB=237
//STEP238     EXEC GENER,LAB=238
//STEP239     EXEC GENER,LAB=239
//STEP240     EXEC GENERO,LAB=240,FM=VBA,LR=137,BKI=32747,BKO=6136
//STEP241     EXEC GENER,LAB=241
//STEP242     EXEC GENER,LAB=242
//STEP243     EXEC GENER,LAB=243
//STEP244     EXEC GENER,LAB=244
//STEP245     EXEC COPY,LAB=245
//STEP246     EXEC GENER,LAB=246
//STEP247     EXEC GENER,LAB=247
//STEP248     EXEC GENER,LAB=248
//STEP249     EXEC GENER,LAB=249
//STEP250     EXEC GENER,LAB=250
//STEP251     EXEC GENER,LAB=251
//STEP252     EXEC GENER,LAB=252
//STEP253     EXEC GENER,LAB=253
//STEP254     EXEC GENER,LAB=254
//STEP255     EXEC GENER,LAB=255
//STEP256     EXEC COPY,LAB=256
//STEP257     EXEC GENER,LAB=257
//STEP258     EXEC GENER,LAB=258
//STEP259     EXEC GENER,LAB=259
//STEP260     EXEC GENER,LAB=260
//STEP261     EXEC GENER,LAB=261
//STEP262     EXEC GENER,LAB=262
//STEP263     EXEC GENER,LAB=263
//STEP264     EXEC GENER,LAB=264
//STEP265     EXEC GENER,LAB=265
//STEP266     EXEC GENER,LAB=266
//STEP267     EXEC COPY,LAB=267
//STEP268     EXEC GENER,LAB=268
//STEP269     EXEC GENER,LAB=269
//STEP270     EXEC GENER,LAB=270
//STEP271     EXEC GENER,LAB=271
//STEP272     EXEC GENER,LAB=272
//STEP273     EXEC GENER,LAB=273
//STEP274     EXEC GENER,LAB=274
//STEP275     EXEC GENER,LAB=275
//STEP276     EXEC GENER,LAB=276
//STEP277     EXEC GENER,LAB=277
