// различные функции общего пользования для работы с файлами БД - use_func.prg
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// 31.01.17
Function R_Use_base(sBase, lAlias)
  return use_base(sBase, lAlias, , .t.)

// 26.07.23 закрывает алиасы для lusl, luslc и luslf
function close_use_base(sBase)
  local countYear, lAlias

  sBase := lower(sBase) // проверим, что алиас открыт и выйдем если нет, пока lusl, luslc, luslf
  if ! substr(sBase, 1, 4) == 'lusl'
    return nil
  endif
  if select(sBase) == 0
    return nil
  endif

  countYear := WORK_YEAR
  lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
  if (lAlias)->(used())
    (lAlias)->(dbCloseArea())
  endif
  return nil

// 12.03.23
function existsNSIfile(sbase, vYear)
  local fl := .f., fName, findex, fIndex_add

  fName := prefixFileRefName(vYear) + substr(sbase, 2)
  if (fl := hb_vfExists(dir_server() + fName + sdbf))
    do case
      case sBase == 'lusl'
        fIndex := cur_dir() + fName + sntx
        if (fl := hb_vfExists(dir_server() + fName + sdbf))
          if ! hb_vfExists(fIndex)
            R_Use(dir_server() + fName, , sBase)
            index on shifr to (fIndex)
            (sBase)->(dbCloseArea())
          endif
        endif
    case sBase == 'luslc'
      fIndex := cur_dir() + fName + sntx
      fIndex_add :=  prefixFileRefName(vYear) + 'uslu'  // 
      if (fl := hb_vfExists(dir_server() + fName + sdbf))
        if (! hb_vfExists(fIndex)) .or. (! hb_vfExists(cur_dir() + fIndex_add + sntx))
          R_Use(dir_server() + fName, , sBase)
          // index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir() + sbase) ;
          index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (findex) ;
              for codemo == glob_mo[_MO_KOD_TFOMS]
          index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (cur_dir() + fIndex_add) ;
              for codemo == glob_mo[_MO_KOD_TFOMS] // для совместимости со старой версией справочника
          (sBase)->(dbCloseArea())
        endif
      endif
    case sBase == 'luslf'
      fName := prefixFileRefName(vYear) + 'uslf'
      fIndex := cur_dir() + fName + sntx
      if (fl := hb_vfExists(dir_server() + fName + sdbf))
        if ! hb_vfExists(fIndex)
          R_Use(dir_server() + fName, , sBase)
          index on shifr to (cur_dir() + fName)
          (sBase)->(dbCloseArea())
        endif
      endif
    endcase
  endif
  return fl


// 26.07.23
Function use_base(sBase, lAlias, lExcluUse, lREADONLY)
  Local fl := .t., sind1 := '', sind2 := ''
  local fname, fname_add
  local countYear

  sBase := lower(sBase)
  do case
    case sBase == 'lusl'
      countYear := WORK_YEAR
      fName := prefixFileRefName(countYear) + substr(sbase, 2)
      lAlias := create_name_alias(sBase, countYear)          
      if ! (lAlias)->(used())
        sind1 := cur_dir() + fName + sntx
        if ! hb_vfExists(sind1)
          R_Use(dir_server() + fName, , lAlias)
          index on shifr to (sind1)
        else
          R_Use(dir_server() + fName, sind1, lAlias)
        endif
      endif
    case sBase == 'luslc'
      countYear := WORK_YEAR
      fName := prefixFileRefName(countYear) + substr(sbase, 2)
      fname_add := prefixFileRefName(countYear) + substr(sbase, 2, 3) + 'u'
      lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
      if ! (lAlias)->(used())
        sind1 := cur_dir() + fName + sntx
        sind2 := cur_dir() + fname_add + sntx
        if ! (hb_vfExists(sind1) .or. hb_vfExists(sind2))
          R_Use(dir_server() + fName, , lAlias)
          index on shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (sind1) ;
              for codemo == glob_mo[_MO_KOD_TFOMS]
          index on codemo + shifr + str(vzros_reb, 1) + str(depart, 3) + dtos(datebeg) to (sind2) ;
              for codemo == glob_mo[_MO_KOD_TFOMS] // для совместимости со старой версией справочника
        else
          R_Use(dir_server() + fName, {cur_dir() + fName, cur_dir() + fName_add}, lAlias)
        endif
      endif
    case sBase == 'luslf'
      countYear := WORK_YEAR
      fName := prefixFileRefName(countYear) + substr(sbase, 2)
      lAlias := sBase + iif(countYear == WORK_YEAR, '', substr(str(countYear, 4), 3))
      if ! (lAlias)->(used())
        sind1 := cur_dir() + fName + sntx
        if ! hb_vfExists(sind1)
          R_Use(dir_server() + fName, , lAlias)
          index on shifr to (sind1)
        else
          R_Use(dir_server() + fName, cur_dir() + fName, lAlias)
        endif
      endif
    case sBase == 'mo_su'
      DEFAULT lAlias TO 'MOSU'
      fl := G_Use(dir_server + 'mo_su', {dir_server + 'mo_su', ;
                                    dir_server + 'mo_sush', ;
                                    dir_server + 'mo_sush1'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'uslugi'
      DEFAULT lAlias TO 'USL'
      fl := G_Use(dir_server + 'uslugi', {dir_server + 'uslugi', ;
                                    dir_server + 'uslugish', ;
                                    dir_server + 'uslugis1', ;
                                    dir_server + 'uslugisl'}, lAlias, , lExcluUse, lREADONLY)
    case sBase == 'lusld'
      fl := R_Use(dir_server()+'_mo_usld',cur_dir() + '_mo_usld',sBase)
  endcase
  return fl

//
Function useUch_Usl()
  return G_Use(dir_server + 'uch_usl', dir_server + 'uch_usl', 'UU') .and. ;
      G_Use(dir_server + 'uch_usl1', dir_server + 'uch_usl1', 'UU1')


// 21.01.19 проверить, заблокирована ли запись, и, если нет, то заблокировать её
Function my_Rec_Lock(n)
  if ascan(dbRLockList(), n) == 0
    G_RLock(forever)
  endif
  return NIL
  
// вернуть в массиве запись базы данных
Function get_field()
  Local arr := array(fcount())
  aeval(arr, {|x, i| arr[i] := fieldget(i) }  )
  return arr
  

// 04.04.18 блокировать запись, где поле KOD == 0 (иначе добавить запись)
Function Add1Rec(n, lExcluUse)
  Local fl := .t., lOldDeleted := SET(_SET_DELETED, .F.)

  DEFAULT lExcluUse TO .f.
  find (str(0, n))
  if found()
    do while kod == 0 .and. !eof()
      if iif(lExcluUse, .t., RLock())
        IF DELETED()
          RECALL
        ENDIF
        fl := .f.
        exit
      endif
      skip
    enddo
  endif
  if fl  // добавление записи
    if lExcluUse
      APPEND BLANK
    else
      DO WHILE .t.
        APPEND BLANK
        IF !NETERR()
          exit
        ENDIF
      ENDDO
    endif
  endif
  SET(_SET_DELETED, lOldDeleted)  // Восстановление среды
  return NIL

// 11.04.18 выравнивание вторичного файла базы данных до первичного
Function dbf_equalization(lAlias, lkod)
  Local fl := .t.

  dbSelectArea(lAlias)
  do while lastrec() < lkod
    do while .t.
      APPEND BLANK
      fl := .f.
      if !NETERR()
        exit
      endif
    enddo
  enddo
  if fl  // т.е. нужная запись не заблокирована при добавлении
    goto (lkod)
    G_RLock(forever)
  endif
  return NIL