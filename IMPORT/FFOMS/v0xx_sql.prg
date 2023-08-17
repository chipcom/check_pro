#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 11.08.23
function make_V0xx(db, source, fOut, fError)

  make_V002(db, source, fOut, fError)
  make_V009(db, source, fOut, fError)
  make_V010(db, source, fOut, fError)
  make_V012(db, source, fOut, fError)
  make_V015(db, source, fOut, fError)
  make_V016(db, source, fOut, fError)
  make_V017(db, source, fOut, fError)
  make_V018(db, source, fOut, fError)
  make_V019(db, source, fOut, fError)
  make_V020(db, source, fOut, fError)
  make_V021(db, source, fOut, fError)
  make_V022(db, source, fOut, fError)
  // // make_V024(db, source)
  make_V025(db, source, fOut, fError)
  make_V030(db, source, fOut, fError)
  make_V031(db, source, fOut, fError)
  make_V032(db, source, fOut, fError)
  make_V033(db, source, fOut, fError)
  make_v036(db, source, fOut, fError)

  return nil

// 11.08.23
Function make_V002(db, source, fOut, fError)
  // IDPR,       "N",      3,      0  // Код профиля медицинской помощи
  // PRNAME,     "C",    350,      0  // Наименование профиля медицинской помощи
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDRP, mPrname, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v002(idpr INTEGER, prname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор профилей оказанной медицинской помощи (ProfOt)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v002') == SQLITE_OK
    fOut:add_string('DROP TABLE v002 - Ok')
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v002 - Ok')
  else
    fOut:add_string('CREATE TABLE v002 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDRP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPR')
        mPrname := read_xml_stroke_1251_to_utf8(oXmlNode, 'PRNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v002(idpr, prname, datebeg, dateend) VALUES(' ;
              + "" + mIDRP + "," ;
              + "'" + mPrname + "'," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V009(db, source, fOut, fError)
  // IDRMP,     "N",   3, 0  // Код результата обращения
  // RMPNAME,   "C", 254, 0  // Наименование результата обращения
  // DL_USLOV,  "N",   2, 0  // Соответствует условиям оказания медицинской помощи (V006)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDRMP, mRmpname, mDL_USLOV, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v009(idrmp INTEGER, rmpname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V009.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор результатов обращения за медицинской помощью (Rezult)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v009') == SQLITE_OK
    fOut:add_string('DROP TABLE v009 - Ok')
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v009 - Ok')
  else
    fOut:add_string('CREATE TABLE v009 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDRMP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDRMP')
        mRmpname := read_xml_stroke_1251_to_utf8(oXmlNode, 'RMPNAME')
        mDL_USLOV := read_xml_stroke_1251_to_utf8(oXmlNode, 'DL_USLOV')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v009(idrmp, rmpname, dl_uslov, datebeg, dateend) VALUES(' ;
              + "" + mIDRMP + "," ;
              + "'" + mRmpname + "'," ;
              + "" + mDL_USLOV + "," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_v010(db, source, fOut, fError)
  // IDSP,       "N",      2,      0  // Код способа оплаты медицинской помощи
  // SPNAME,     "C",    254,      0  // Наименование способа оплаты медицинской помощи
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDSP, mSpname, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v010(idsp INTEGER, spname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор способов оплаты медицинской помощи (Sposob)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v010') == SQLITE_OK
    fOut:add_string('DROP TABLE v010 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v010 - Ok')
  else
    fOut:add_string('CREATE TABLE v010 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDSP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDSP')
        mSpname := read_xml_stroke_1251_to_utf8(oXmlNode, 'SPNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v010(idsp, spname, datebeg, dateend) VALUES(' ;
              + "" + mIDSP + "," ;
              + "'" + mSpname + "'," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V012(db, source, fOut, fError)
  // IDIZ,      "N",   3, 0  // Код исхода заболевания
  // IZNAME,    "C", 254, 0  // Наименование исхода заболевания
  // DL_USLOV,  "N",   2, 0  // Соответствует условиям оказания МП (V006)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDIZ, mIzname, mDL_USLOV, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v012(idiz INTEGER, izname TEXT, dl_uslov INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V012.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор исходов заболевания (Ishod)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v012') == SQLITE_OK
    fOut:add_string('DROP TABLE v012 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v012 - Ok')
  else
    fOut:add_string('CREATE TABLE v012 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDIZ := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDIZ')
        mIzname := read_xml_stroke_1251_to_utf8(oXmlNode, 'IZNAME')
        mDL_USLOV := read_xml_stroke_1251_to_utf8(oXmlNode, 'DL_USLOV')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v012(idiz, izname, dl_uslov, datebeg, dateend) VALUES(' ;
              + "" + mIDIZ + "," ;
              + "'" + mIzname + "'," ;
              + "" + mDL_USLOV + "," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V015(db, source, fOut, fError)
  // RECID,  "N",    3,      0      // Номер записи
  // CODE,   "N",    4,      0      // Код специальности
  // NAME,   "C",  254,      0      // Наименование специальности
  // HIGH,   "N",    4,      0      // Принадлежность (иерархия)
  // OKSO,   "N",    3,      0      // Значение ОКСО
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mRecid, mCode, mName, mHigh, mOKSO, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v015(recid INTEGER, code INTEGER, name TEXT, high TEXT(4), okso TEXT(3), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор медицинских специальностей (Medspec)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v015') == SQLITE_OK
    fOut:add_string('DROP TABLE v015 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v015 - Ok')
  else
    fOut:add_string('CREATE TABLE v015 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mRecid := read_xml_stroke_1251_to_utf8(oXmlNode, 'RECID')
        mCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE')
        mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')
        mHigh := read_xml_stroke_1251_to_utf8(oXmlNode, 'HIGH')
        mOKSO := read_xml_stroke_1251_to_utf8(oXmlNode, 'OKSO')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v015(recid, code, name, high, okso, datebeg, dateend) VALUES(' ;
              + "" + mRecid + "," ;
              + "" + mCode + "," ;
              + "'" + mName + "'," ;
              + "'" + mHigh + "'," ;
              + "'" + mOKSO + "'," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V016(db, source, fOut, fError)
  // IDDT,     "C",        3,      0 // Код типа диспансеризации
  // DTNAME,   "C",      254,      0 // Наименование типа диспансеризации
  // RULE,     "N",        2,      0 // Значение результата диспансеризации (Заполняется в соответствии с классификатором V017)
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mIDDT, mDTNAME, mRule, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v016(iddt TEXT(3), dtname TEXT, rule TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор типов диспансеризации (DispT)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v016') == SQLITE_OK
    fOut:add_string('DROP TABLE v016 - Ok')
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v016 - Ok')
  else
    fOut:add_string('CREATE TABLE v016 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDDT := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDT')
        mDTNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'DTNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        mRule := ''
        if (oNode1 := oXmlNode:Find('DTRULE')) != NIL
          for j1 := 1 TO Len( oNode1:aItems )
            oNode2 := oNode1:aItems[j1]
            if 'RULE' == oNode2:title .and. !empty(oNode2:aItems) .and. valtype(oNode2:aItems[1]) == 'C'
              mRule := mRule + iif(empty(mRule), '', ',') + alltrim(oNode2:aItems[1])
            endif
          next
        endif
  
        count++
        cmdTextInsert += 'INSERT INTO v016(iddt, dtname, rule, datebeg, dateend) VALUES(' ;
              + "'" + mIDDT + "'," ;
              + "'" + mDTNAME + "'," ;
              + "'" + mRule + "'," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V017(db, source, fOut, fError)
  // IDDR,     "N",        2,      0 // Код результата диспансеризации
  // DRNAME,   "C",      254,      0 // Наименование результата диспансеризации
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDDR, mDRNAME, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v017(iddr INTEGER, drname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор результатов диспансеризации (DispR)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v017') == SQLITE_OK
    fOut:add_string('DROP TABLE v017 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v017 - Ok')
  else
    fOut:add_string('CREATE TABLE v017 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDDR := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDR')
        mDRNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'DRNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v017(iddr, drname, datebeg, dateend) VALUES(' ;
            + "" + mIDDR + "," ;
            + "'" + mDRNAME + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V018(db, source, fOut, fError)
  // IDHVID,     "C",     12,      0 // Код вида высокотехнологичной медицинской помощи
  // HVIDNAME,   "C",   1000,      0 // Наименование вида высокотехнологичной медицинской помощи
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDHVID, mHVIDNAME, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v018(idhvid TEXT(12), hvidname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V018.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор видов высокотехнологичной медицинской помощи (HVid)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v018') == SQLITE_OK
    fOut:add_string('DROP TABLE v018 - Ok')
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v018 - Ok')
  else
    fOut:add_string('CREATE TABLE v018 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDHVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDHVID')
        mHVIDNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'HVIDNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v018(idhvid, hvidname, datebeg, dateend) VALUES(' ;
            + "'" + mIDHVID + "'," ;
            + "'" + mHVIDNAME + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_V019(db, source, fOut, fError)
  // IDHM,       "N",      4,      0 // Идентификатор метода высокотехнологичной медицинской помощи
  // HMNAME,     "C",   1000,      0; // Наименование метода высокотехнологичной медицинской помощи
  // DIAG,       "C",   1000,      0 // Верхние уровни кодов диагноза по МКБ для данного метода; указываются через разделитель ";".
  // HVID,       "C",     12,      0 // Код вида высокотехнологичной медицинской помощи для данного метода
  // HGR,        "N",      3,      0 // Номер группы высокотехнологичной медицинской помощи для данного метода
  // HMODP,      "C",   1000,      0 // Модель пациента для методов высокотехнологичной медицинской помощи с одинаковыми значениями поля "HMNAME". Не заполняется, начиная с версии 3.0
  // IDMODP,     "N",      5,      0 // Идентификатор модели пациента для данного метода (начиная с версии 3.0, заполняется значением поля IDMPAC классификатора V022)
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0 // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDHM, mHMNAME, mDIAG, mHVID, mHGR, mHMODP, mIDMODP, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v019(idhm INTEGER, hmname BLOB, diag BLOB, hvid TEXT(12), hgr INTEGER, hmodp BLOB, idmodp INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V019.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор методов высокотехнологичной медицинской помощи (HMet)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v019') == SQLITE_OK
    fOut:add_string('DROP TABLE v019 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v019 - Ok')
  else
    fOut:add_string('CREATE TABLE v019 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDHM := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDHM')
        mHMNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'HMNAME')
        mDIAG := read_xml_stroke_1251_to_utf8(oXmlNode, 'DIAG')
        mHVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'HVID')
        mHGR := read_xml_stroke_1251_to_utf8(oXmlNode, 'HGR')
        mHMODP := read_xml_stroke_1251_to_utf8(oXmlNode, 'HMODP')
        mIDMODP := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDMODP')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v019(idhm, hmname, diag, hvid, hgr, hmodp, idmodp, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mIDHM))) + "," ;
            + "'" + mHMNAME + "'," ;
            + "'" + mDIAG + "'," ;
            + "'" + mHVID + "'," ;
            + "" + alltrim(str(val(mHGR))) + "," ;
            + "'" + mHMODP + "'," ;
            + "" + alltrim(str(val(mIDMODP))) + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return NIL

// 11.08.23
Function make_V020(db, source, fOut, fError)
  // IDK_PR,     "N",      3,      0 // Код профиля койки
  // K_PRNAME,   "C",    254,      0 // Наименование профиля койки
  // DATEBEG,    "D",      8,      0 // Дата начала действия записи
  // DATEEND,    "D",      8,      0  // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDK_PR, mK_PRNAME, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v020(idk_pr INTEGER, k_prname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V020.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор профиля койки (KoPr)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v020') == SQLITE_OK
    fOut:add_string('DROP TABLE v020 - Ok')
  endif
   if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v020 - Ok')
  else
    fOut:add_string('CREATE TABLE v020 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDK_PR := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDK_PR')
        mK_PRNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'K_PRNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v020(idk_pr, k_prname, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mIDK_PR))) + "," ;
            + "'" + mK_PRNAME + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return NIL

// 12.08.23
Function make_V021(db, source, fOut, fError)
  // IDSPEC,     "N",      3,      0  // Код специальности
  // SPECNAME,   "C", 254             // Наименование специальности
  // POSTNAME,   "C",    400,      0  // Наименование должности
  // IDPOST_MZ,   "C",    4,      0  // Код должности в соответствии с НСИ Минздрава России (OID 1.2.643.5.1.13.13.11.1002)
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи
  
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDSPEC, mSPECNAME, mPOSTNAME, mIDPOST_MZ, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v021(idspec INTEGER, specname BLOB, postname BLOB, idpost_mz TEXT(4), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V021.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор медицинских специальностей (должностей) (MedSpec)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v021') == SQLITE_OK
    fOut:add_string('DROP TABLE v021 - Ok')
  endif
   
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v021 - Ok')
  else
    fOut:add_string('CREATE TABLE v021 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDSPEC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDSPEC')
        mSPECNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'SPECNAME')
        mPOSTNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'POSTNAME')
        mIDPOST_MZ := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPOST_MZ')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v021(idspec, specname, postname, idpost_mz, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mIDSPEC))) + "," ;
            + "'" + mSPECNAME + "'," ;
            + "'" + mPOSTNAME + "'," ;
            + "'" + mIDPOST_MZ + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V022(db, source, fOut, fError)
  // IDMPAC,     "N",      5,      0  //  Идентификатор модели пациента
  // MPACNAME,   "M",     10,      0  // Наименование модели пациента
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи
  
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDMPAC, mMPACNAME, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v022(idmpac INTEGER, mpacname BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V022.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор моделей пациента при оказании высокотехнологичной медицинской помощи (ModPac)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v022') == SQLITE_OK
    fOut:add_string('DROP TABLE v022 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v022 - Ok')
  else
    fOut:add_string('CREATE TABLE v022 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDMPAC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDMPAC')
        mMPACNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'MPACNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        if d1_1 >= 0d20210101 .or. Empty(d2_1)  //0d20210101

          Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
          d1 := hb_ValToStr(d1_1)
          d2 := hb_ValToStr(d2_1)

          count++
          cmdTextInsert += 'INSERT INTO v022(idmpac, mpacname, datebeg, dateend) VALUES(' ;
              + "" + alltrim(str(val(mIDMPAC))) + "," ;
              + "'" + mMPACNAME + "'," ;
              + "'" + d1 + "'," ;
              + "'" + d2 + "');"
          if count == COMMIT_COUNT
            cmdTextInsert += textCommitTrans
            sqlite3_exec(db, cmdTextInsert)
            count := 0
            cmdTextInsert := textBeginTrans
          endif
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V025(db, source, fOut, fError)
  // IDPC,      "C",   3, 0  // Код цели посещения
  // N_PC,      "C", 254, 0  // Наименование цели посещения
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDPC, mN_PC, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v025(idpc TEXT(3), n_pc BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V025.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Классификатор целей посещения (KPC)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v025') == SQLITE_OK
    fOut:add_string('DROP TABLE v025 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v025 - Ok')
  else
    fOut:add_string('CREATE TABLE v025 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty(oXmlDoc:aItems)
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDPC := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDPC')
        mN_PC := read_xml_stroke_1251_to_utf8(oXmlNode, 'N_PC')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v025(idpc, n_pc, datebeg, dateend) VALUES(' ;
            + "'" + mIDPC + "'," ;
            + "'" + mN_PC + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V030(db, source, fOut, fError)
  // SCHEMCOD,  "C",   5, 0  // 
  // SCHEME,    "C",  15, 0  //
  // DEGREE,    "N",   2, 0  //
  // COMMENT,   "M",  10, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mSchemCode, mScheme, mDegree, mComment, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v030(schemcode TEXT(5), scheme TEXT(15), degree INTEGER, comment BLOB, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V030.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Схемы лечения заболевания COVID-19 (TreatReg)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v030') == SQLITE_OK
    fOut:add_string('DROP TABLE v030 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v030 - Ok')
  else
    fOut:add_string('CREATE TABLE v030 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mSchemCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'SchemCode')
        mScheme := read_xml_stroke_1251_to_utf8(oXmlNode, 'Scheme')
        mDegree := read_xml_stroke_1251_to_utf8(oXmlNode, 'DegreeSeverity')
        mComment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')
            
        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v030(schemcode, scheme, degree, comment, datebeg, dateend) VALUES(' ;
            + "'" + mSchemCode + "'," ;
            + "'" + mScheme + "'," ;
            + "" + alltrim(str(val(mDegree))) + "," ;
            + "'" + mComment + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V031(db, source, fOut, fError)
  // DRUGCODE,  "N",   2, 0  // 
  // DRUGGRUP,  "C",  50, 0  //
  // INDMNN,    "N",   2, 0  // Признак обязательности указания МНН (1-да, 0-нет)
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mDrugCode, mDrugGrup, mIndMNN, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v031(drugcode INTEGER, druggrup TEXT, indmnn INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V031.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v031') == SQLITE_OK
    fOut:add_string('DROP TABLE v031 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v031 - Ok')
  else
    fOut:add_string('CREATE TABLE v031 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mDrugCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugGroupCode')
        mDrugGrup := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugGroup')
        mIndMNN := read_xml_stroke_1251_to_utf8(oXmlNode, 'ManIndMNN')
          
        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v031(drugcode, druggrup, indmnn, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mDrugCode))) + "," ;
            + "'" + mDrugGrup + "'," ;
            + "" + alltrim(str(val(mIndMNN))) + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V032(db, source, fOut, fError)
  // SCHEDRUG,  "C",  10, 0  // Сочетание схемы лечения и группы препаратов
  // NAME,      "C", 100, 0  //
  // SCHEMCODE,  "C",   5, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0  // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mScheDrug, mName, mSchemCode, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v032(schedrug TEXT(10), name TEXT, schemcode TEXT(5), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V032.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Сочетание схемы лечения и группы препаратов (CombTreat)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v032') == SQLITE_OK
    fOut:add_string('DROP TABLE v032 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v032 - Ok')
  else
    fOut:add_string('CREATE TABLE v032 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mScheDrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'ScheDrugGrCd')
        mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'Name')
        mSchemCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'SchemCode')
            
        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v032(schedrug, name, schemcode, datebeg, dateend) VALUES(' ;
            + "'" + mScheDrug + "'," ;
            + "'" + mName + "'," ;
            + "'" + mSchemCode + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V033(db, source, fOut, fError)
  // SCHEDRUG,  "C",  10, 0  // 
  // DRUGCODE,  "C",   6, 0  //
  // DATEBEG,   "D",   8, 0  // Дата начала действия записи
  // DATEEND,   "D",   8, 0   // Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mScheDrug, mDrugCode, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v033(schedrug TEXT(10), drugcode TEXT(6), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'V033.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Соответствие кода препарата схеме лечения (DgTreatReg)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v033') == SQLITE_OK
    fOut:add_string('DROP TABLE v033 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v033 - Ok')
  else
    fOut:add_string('CREATE TABLE v033 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mScheDrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'ScheDrugGrCd')
        mDrugCode := read_xml_stroke_1251_to_utf8(oXmlNode, 'DrugCode')
  
        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v033(schedrug, drugcode, datebeg, dateend) VALUES(' ;
            + "'" + mScheDrug + "'," ;
            + "'" + mDrugCode + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V036(db, source, fOut, fError)
  // S_CODE    "C",  16, 0
  // NAME",      "C", 150, 0
  // "PARAM",     "N",   1, 0
  // "COMMENT",   "C",  20, 0
  // "DATEBEG",   "D",   8, 0 Дата начала действия записи
  // "DATEEND",   "D",   8, 0 Дата окончания действия записи

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mS_Code, mName, mParam, mComment, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE v036( s_code TEXT(16), name BLOB, param INTEGER, comment TEXT, datebeg TEXT(10), dateend TEXT(10) )'

  nameRef := 'V036.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v036') == SQLITE_OK
    fOut:add_string('DROP TABLE v036 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v036 - Ok')
  else
    fOut:add_string('CREATE TABLE v036 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mS_Code := read_xml_stroke_1251_to_utf8(oXmlNode, 'S_CODE')
        mName := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')
        mParam := read_xml_stroke_1251_to_utf8(oXmlNode, 'Parameter')
        mComment := read_xml_stroke_1251_to_utf8(oXmlNode, 'COMMENT')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)
          
        count++
        cmdTextInsert += 'INSERT INTO v036(s_code, name, param, comment, datebeg, dateend) VALUES(' ;
            + "'" + mS_Code + "'," ;
            + "'" + mName + "'," ;
            + "" + alltrim(str(val(mParam))) + "," ;
            + "'" + mComment + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_V024(db, source, fOut, fError)
  // IDDKK,     "C",  10,      0  //  Идентификатор модели пациента
  // DKKNAME,   "C", 255,      0  // Наименование модели пациента
  // DATEBEG,   "D",   8, 0           // Дата начала действия записи
  // DATEEND,   "D",   8, 0           // Дата окончания действия записи
  
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDDKK, mDKKNAME, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'V024.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  cmdText := 'CREATE TABLE v024(iddkk TEXT(10), dkkname TEXT, datebeg TEXT(10), dateend TEXT(10))'
  fOut:add_string(hb_eol() + nameRef + ' - Классификатор классификационных критериев (DopKr)')

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS v024') == SQLITE_OK
    fOut:add_string('DROP TABLE v024 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE v024 - Ok')
  else
    fOut:add_string('CREATE TABLE v024 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        mIDDKK := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDKK')
        mDKKNAME := read_xml_stroke_1251_to_utf8(oXmlNode, 'DKKNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO v024(iddkk, dkkname, datebeg, dateend) VALUES(' ;
            + "'" + mIDDKK + "'," ;
            + "'" + mDKKNAME + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil
