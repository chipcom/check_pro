#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'
#include 'tbox.ch'

function select_mo()
  local dbName := '_mo_mo'
  local standart, uroven
  local _arr := {}
  // _mo_mo.dbf - справочник медучреждений
  //  1 - MCOD(C)  2 - CODEM(C)  3 - NAMEF(C)  4 - NAMES(C) 5 - ADRES(C) 6 - MAIN(C)
  //  7 - PFA(C) 8 - PFS(C) 9 - PROD(C) 10 - DOLG(C) 
  //  11 - DEND(D)  12 - STANDART(C)  13 - UROVEN(C)

  dbUseArea( .t., , cur_dir() + dbName, dbName, .f., .f. )

    // (dbName)->(dbGoTop())
    // do while !(dbName)->(EOF())
    //   standart := {}
    //   uroven := {}

    //   hb_jsonDecode( (dbName)->STANDART, @standart )
    //   hb_jsonDecode( (dbName)->UROVEN, @uroven )

    //   for each row in standart
    //     row[1] := hb_SToD(row[1])
    //   next
    //   for each row in uroven
    //     row[1] := hb_SToD(row[1])
    //   next

    //   aadd(_arr, { ;
    //           alltrim((dbName)->NAMES), ;
    //           alltrim((dbName)->CODEM), ;
    //           (dbName)->PROD, ;
    //           (dbName)->DEND, ;
    //           alltrim((dbName)->MCOD), ;
    //           alltrim((dbName)->NAMEF), ;
    //           uroven, ; // уровень оплаты, с 2013 года 4 - индивидуальные тарифы
    //           standart, ;
    //           (dbName)->MAIN == '1', ;
    //           (dbName)->PFA == '1', ;
    //           (dbName)->PFS == '1', ;
    //           alltrim((dbName)->ADRES) ;
    //     } )

    //   (dbName)->(dbSkip())
    // enddo
    // (dbName)->(dbCloseArea())

    // if hb_FileExists(dir_server + sbase + sdbf)
    //   dbUseArea( .t.,, dir_server + sbase, sbase, .f., .f. )
    //   // dbUseArea( .t., , dbName, dbName, .f., .f. )
    //   (sbase)->(dbGoTop())
    //   do while !(sbase)->(EOF())

    //   aadd(_arr, { ;
    //           alltrim((sbase)->NAMES), ;
    //           alltrim((sbase)->CODEM), ;
    //           '', ;
    //           (sbase)->DEND, ;
    //           alltrim((sbase)->MCOD), ;
    //           alltrim((sbase)->NAMEF), ;
    //           {}, ; // уровень оплаты, с 2013 года 4 - индивидуальные тарифы
    //           {}, ;
    //           '1', ;
    //           '0', ;
    //           '0', ;
    //           alltrim((sbase)->ADRES) ;
    //     } )
    //     (sbase)->(dbSkip())
    //   enddo
    //   (sbase)->(dbCloseArea())
    //   endif
  return _arr  